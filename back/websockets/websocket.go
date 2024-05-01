package websockets

import (
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
	socketio "github.com/googollee/go-socket.io"
)

func RegisterWebsocket(r *gin.Engine) *socketio.Server {
	server := socketio.NewServer(nil)

	server.OnConnect("/", connectHandler)
	server.OnEvent("/", "test", func(s socketio.Conn, msg string) {
		fmt.Println("test:", msg)
		s.Emit("test", msg)
	})
	server.OnError("/", func(s socketio.Conn, e error) {
		fmt.Fprintf(os.Stderr, "Soket.io error: %v\n", e)
	})
	server.OnDisconnect("/", disconnectHandler)

	go listen(server)

	r.GET("/socket.io/*any", gin.WrapH(server))

	return server
}

func listen(s *socketio.Server) {
	if err := s.Serve(); err != nil {
		fmt.Println("Error: ", err)
	}
}

func connectHandler(s socketio.Conn) error {
	s.SetContext("")
	fmt.Println("connected:", s.ID())
	return nil
}

func disconnectHandler(s socketio.Conn, reason string) {
	fmt.Println("disconnected:", s.ID(), reason)
}
