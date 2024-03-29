#!/bin/bash
cd /app
echo "Starting the code server on port $CODE_SERVER_PORT for repo $GIT_REPO_URL"

source ./venv/bin/activate

if [ -f requirements.txt ]; then 
    pip install -r requirements.txt; 
fi
code-server --bind-addr "0.0.0.0:${CODE_SERVER_PORT}" --auth none --disable-telemetry --disable-update-check /app