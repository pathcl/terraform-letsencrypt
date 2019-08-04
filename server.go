package main

import (
	"log"
	"net/http"
)

func HelloServer(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("It works!.\n"))
}

func main() {
	log.Println("Server started.")
	http.HandleFunc("/", HelloServer)
	err := http.ListenAndServeTLS(":8443", "server.pem", "server.key", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
