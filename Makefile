# ビルドのためのMakefile

# ワーキングディレクトリの設定
WORKING:=$(CURDIR)

RPCDIR=$(WORKING)/rpc
OUTDIR=$(WORKING)/dist
GO_AUTOGENED=$(OUTDIR)/autogen/go/api/**/*.go

# サーバ側の変数
GO_SRVDIR=$(WORKING)/cmd/server
GO_SRVBIN=$(OUTDIR)/cardgame-server

# クライアント側の変数
GO_CLIDIR=$(WORKING)/cmd/client/go
GO_CLIBIN=$(OUTDIR)/cardgame-client

# ビルド
.PHONY: all
all: $(GO_AUTOGENED) $(GO_SRVBIN) $(GO_CLIBIN)

# protocol bufferのビルド
.PHONY: bufbuild
bufbuild: 
	$(GO_AUTOGENED)

# サーバーのビルド
$(GO_SRVBIN): $(shell find $(GO_SRVDIR) -type f -name '*.go' -print)
	gofmt -l -w $?
	staticcheck $?
	go vet $?
	go build -o $@ $(GO_SRVDIR)

# クライアントのビルド
$(GO_CLIBIN): $(shell find $(GO_CLIDIR) -type f -name '*.go' -print)
	gofmt -l -w $?
	staticcheck $?
	go vet $?
	go build -o $@ $(GO_CLIDIR)

# buf側のビルド前処理
$(GO_AUTOGENED): $(shell find $(RPCDIR) -type f -name '*.proto' -print)
	buf mod update $(RPCDIR)
	buf lint
	buf format -w
	buf generate

# 実行ファイルの削除
.PHONY: clean
clean:
	@rm -rf $(OUTDIR)/*
