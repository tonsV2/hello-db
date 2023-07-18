package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
	"log"
	"net/http"
	"os"
	"strconv"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func run() error {
	hostname := requireEnv("DATABASE_HOST")
	port, err := strconv.ParseInt(requireEnv("DATABASE_PORT"), 10, 32)
	if err != nil {
		return err
	}
	username := requireEnv("DATABASE_USERNAME")
	password := requireEnv("DATABASE_PASSWORD")
	database := requireEnv("DATABASE_NAME")
	dsn := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", hostname, port, username, password, database)

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return err
	}

	s := &service{db: db}

	err = http.ListenAndServe(":8080", s)
	if err != nil {
		return err
	}

	return nil
}

func requireEnv(key string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		log.Fatalf("Can't find environment variable: %s\n", key)
	}
	return value
}

type service struct {
	db *sql.DB
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	logRequest(r)
	switch r.URL.Path {
	default:
		http.Error(w, "not found", http.StatusNotFound)
		return
	case "/health":
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		if _, err := w.Write([]byte(`{"status": "UP"}`)); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		return
	case "/":
		var now string
		if err := s.db.QueryRow("select now()").Scan(&now); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
		w.WriteHeader(http.StatusOK)
		if _, err := w.Write([]byte(now)); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}

func logRequest(r *http.Request) {
	log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL)
}
