package logic

import (
	"context"

	"connectrpc.com/connect"
	apiv1 "github.com/JanStanleyWatt/testing-cardgame/dist/autogen/go/api/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// この空構造体にGameServiceHandlerインターフェースを実装する
type GameServer struct{}

// JoinGame is a method of GameServer
func (s *GameServer) JoinGame(
	ctx context.Context, req *connect.Request[apiv1.JoinGameRequest]) (*connect.Response[apiv1.JoinGameResponse], error) {

	if err := ctx.Err(); err != nil {
		return nil, err // automatically coded correctly
	}

	res := connect.NewResponse(&apiv1.JoinGameResponse{
		Success:      true,
		Message:      "Welcome!",
		ResponseTime: timestamppb.Now(),
	})

	return res, nil
}
