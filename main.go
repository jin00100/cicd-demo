package main
import "fmt"
import "net/http"

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, CI/CD with Jenkins and Docker! V1.0")
    })
    http.ListenAndServe(":8080", nil)
}
