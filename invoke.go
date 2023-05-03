// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// [START cloudrun_report_server]

// Service gcloud-report is a Cloud Run shell-script-as-a-service.
package main

import (
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	http.HandleFunc("/createjob", scriptHandler)
	http.HandleFunc("/observe", observeHandler)
	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("defaulting to port %s", port)
	}

	// Start HTTP server.
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func scriptHandler(w http.ResponseWriter, r *http.Request) {
	start_date := r.URL.Query().Get("start_date")
	end_date := r.URL.Query().Get("end_date")
	log_bucket := r.URL.Query().Get("log_bucket")
	export_bucket := r.URL.Query().Get("export_bucket")
	location := r.URL.Query().Get("location")

	cmd := exec.CommandContext(r.Context(), "/bin/bash", "script.sh", start_date, end_date, log_bucket, export_bucket, location)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		log.Printf("Command.Output: %v", err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	w.Write(out)
}

func observeHandler(w http.ResponseWriter, r *http.Request) {
	job_id := r.URL.Query().Get("job_id")
	location := r.URL.Query().Get("location")
	if len(job_id) == 0 {
		log.Printf("Please set Job ID")
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}

	cmd := exec.CommandContext(r.Context(), "/bin/bash", "script_observe.sh", job_id, location)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		log.Printf("Command.Output: %v", err)
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
		return
	}
	w.Write(out)
}

// [END cloudrun_report_server]
