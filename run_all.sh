#!/bin/bash
set -e

# Always run from project root
cd "$(dirname "$0")"

# Activate virtual environment
echo "Activating virtual environment..."

source .venv/bin/activate

# Start backend with uvicorn (correct way)
echo "Starting backend on http://127.0.0.1:8000 ..."
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload &

# Give backend a moment to start
sleep 2

# Start Streamlit frontend
echo "Starting Streamlit on http://127.0.0.1:8501 ..."
streamlit run ui/streamlit_app.py --server.port 8501
