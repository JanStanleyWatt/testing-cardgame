WORKING:=${CURDIR}

RPCDIR:=${WORKING}/rpc
DISTDIR:=${WORKING}/dist

SRVDIR:=${WORKING}/cmd/server

GENDIR:=${WORKING}/pkg/gen

# ビルド
.PHONY: all
all: buf-prebuild go-prebuild  ${DISTDIR}/server

# サーバーのビルド
${DISTDIR}/server:
	go build -o ${DISTDIR} ${SRVDIR}

# Go側のビルド前処理
.PHONY: go-prebuild
go-prebuild:
	go fmt ${WORKING}/cmd/...
	staticcheck ${WORKING}/cmd/...
	go vet ${WORKING}/cmd/...

# buf側のビルド前処理
.PHONY: buf-prebuild
buf-prebuild:
	cd ${RPCDIR} && buf mod update
	buf lint
	buf format -w
	buf generate

# 実行ファイルの清掃
.PHONY: clean
clean:
	@rm -rf ${DISTDIR}/*
