package main

import (
	"fmt"
	"net/http"

	"github.com/JanStanleyWatt/testing-cardgame/cmd/server/handler"
	"github.com/JanStanleyWatt/testing-cardgame/pkg/autogen/api/v1/apiv1connect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

func main() {
	gameserver := &handler.GameServer{}
	mux := http.NewServeMux()

	path, handler := apiv1connect.NewGameServiceHandler(gameserver)

	// 仮のログ出力。後ほどslogパッケージを使ってログ出力を行う
	fmt.Println("Starting server...")
	fmt.Println(path)

	mux.Handle(path, handler)

	http.ListenAndServe(":8080", h2c.NewHandler(mux, &http2.Server{}))
}
