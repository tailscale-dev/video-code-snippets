import requests
import time
import random
from concurrent.futures import ThreadPoolExecutor
from itertools import cycle
import os

PROMETHEUS_URL = "http://prometheus.velociraptor-noodlefish.ts.net:9090"
ENDPOINTS = [
    "/api/v1/query?query=up",
    "/api/v1/query?query=rate(tailscaled_inbound_bytes_total[5m])",
    "/api/v1/query_range?query=tailscaled_health_messages&start=2024-02-05T00:00:00Z&end=2024-02-05T01:00:00Z&step=15s",
    "/metrics",
    "/api/v1/labels",
    "/api/v1/targets"
]

NUM_WORKERS = 10  # Concurrent threads
REQUESTS_PER_BATCH = 20  # Requests per worker

def make_request(endpoint):
    try:
        response = requests.get(f"{PROMETHEUS_URL}{endpoint}", timeout=2)
        status = response.status_code
        print(f"Request to {endpoint}: {status}", flush=True)
        return status
    except Exception as e:
        print(f"Error requesting {endpoint}: {e}", flush=True)
        return 0

def worker(worker_id):
    endpoints_cycle = cycle(ENDPOINTS)
    requests_made = 0
    
    while True:
        endpoint = next(endpoints_cycle)
        make_request(endpoint)
        requests_made += 1
        
        if requests_made % 100 == 0:
            print(f"Worker {worker_id} has made {requests_made} requests", flush=True)
        
        time.sleep(random.uniform(0.01, 0.1))  # Small random delay

def generate_load():
    print(f"Starting load generation with {NUM_WORKERS} workers...")
    with ThreadPoolExecutor(max_workers=NUM_WORKERS) as executor:
        futures = [executor.submit(worker, i) for i in range(NUM_WORKERS)]
        try:
            # Wait for all futures to complete (they won't unless interrupted)
            for future in futures:
                future.result()
        except KeyboardInterrupt:
            print("Stopping load generation...")

if __name__ == "__main__":
    print("Initializing high-load generator...")
    generate_load()