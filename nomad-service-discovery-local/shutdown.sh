#!/bin/sh

export NOMAD_ADDR=http://127.0.0.1:4646
## Stop jobs

echo "Stopping jobs"
nomad job stop backend
nomad job stop frontend

sleep 20

echo "Shutting down Nomad"
pkill nomad

