# ビルドのためのMakefile

# ワーキングディレクトリの設定
WORKING:=$(CURDIR)

RPCDIR=$(WORKING)/rpc
OUTDIR=$(WORKING)/dist
AUTOGENED=$(shell find $(OUTDIR)/autogen -type f -name '*.go' -print)

# サーバ側の変数
GO_SRVDIR=$(WORKING)/cmd/server
GO_SRVBIN=$(OUTDIR)/cardgame-server

# クライアント側の変数
GO_CLIDIR=$(WORKING)/cmd/client/go
GO_CLIBIN=$(OUTDIR)/cardgame-client

# ビルド
.PHONY: all
all: $(AUTOGENED) $(GO_SRVBIN) $(GO_CLIBIN)

# サーバーのビルド
$(GO_SRVBIN): $(shell find $(GO_SRVDIR) -type f -name '*.go' -print)
	go fmt $?
	staticcheck $?
	go vet $?
	go build -o $@ $(GO_SRVDIR)

# クライアントのビルド
$(GO_CLIBIN): $(shell find $(GO_CLIDIR) -type f -name '*.go' -print)
	go fmt $?
	staticcheck $?
	go vet $?
	go build -o $@ $(GO_CLIDIR)

# buf側のビルド前処理
$(AUTOGENED): $(shell find $(RPCDIR) -type f -name '*.proto' -print)
	buf mod update $(RPCDIR)
	buf lint
	buf format -w
	buf generate

# 実行ファイルの削除
.PHONY: clean
clean:
	@rm -rf $(OUTDIR)/*
