package main

import (
	"context"
	"fmt"
	"net/http"

	"connectrpc.com/connect"
	apiv1 "github.com/JanStanleyWatt/testing-cardgame/dist/autogen/go/api/v1"
	"github.com/JanStanleyWatt/testing-cardgame/dist/autogen/go/api/v1/apiv1connect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Empty struct for GameServer
// この空構造体にGameServiceHandlerインターフェースを実装する
type GameServer struct{}

// JoinGame is a method of GameServer
func (s *GameServer) JoinGame(
	ctx context.Context, req *connect.Request[apiv1.JoinGameRequest]) (*connect.Response[apiv1.JoinGameResponse], error) {

	res := connect.NewResponse(&apiv1.JoinGameResponse{
		Success:      true,
		Message:      "Welcome!",
		ResponseTime: timestamppb.Now(),
	})

	return res, nil
}

func main() {
	gameserver := &GameServer{}
	mux := http.NewServeMux()

	path, handler := apiv1connect.NewGameServiceHandler(gameserver)

	// 仮のログ出力。後ほどslogパッケージを使ってログ出力を行う
	fmt.Println("Starting server...")
	fmt.Println(path)

	mux.Handle(path, handler)

	http.ListenAndServe(":8080", h2c.NewHandler(mux, &http2.Server{}))
}
