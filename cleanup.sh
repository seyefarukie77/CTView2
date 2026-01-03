#!/bin/bash

echo "=== CTView Cleanup Script ==="

# Safety check
read -p "This will reorganise your CTView project. Continue? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    exit 1
fi

echo "Cleaning up and restructuring CTView..."

# ---------------------------------------------------------
# 1. Create new recommended folder structure
# ---------------------------------------------------------
mkdir -p app/core
mkdir -p app/api
mkdir -p app/db
mkdir -p docker

# ---------------------------------------------------------
# 2. Move backend files into new structure (if they exist)
# ---------------------------------------------------------
if [ -f app/infrastructure/config.py ]; then
    mv app/infrastructure/config.py app/core/config.py
fi

if [ -f app/infrastructure/logging_config.py ]; then
    mv app/infrastructure/logging_config.py app/core/logging_config.py
fi

if [ -f app/db/dbconn.py ]; then
    mv app/db/dbconn.py app/db/dbconn.py
fi

# ---------------------------------------------------------
# 3. Move API routers into app/api
# ---------------------------------------------------------
if [ -d app/routers ]; then
    mv app/routers/* app/api/
    rmdir app/routers
fi

# ---------------------------------------------------------
# 4. Remove unused or deprecated folders
# ---------------------------------------------------------
DELETE_FOLDERS=(
    "analytics"
    "app/scripts"
    "app/infrastructure"
    "run_app.py"
    "run_streamlit.sh"
    "infrastructure"
)

for folder in "${DELETE_FOLDERS[@]}"; do
    if [ -e "$folder" ]; then
        echo "Removing $folder..."
        rm -rf "$folder"
    fi
done

# ---------------------------------------------------------
# 5. Ensure data folder exists
# ---------------------------------------------------------
mkdir -p data/survey

# ---------------------------------------------------------
# 6. Create Dockerfile placeholders if missing
# ---------------------------------------------------------
if [ ! -f docker/Dockerfile.backend ]; then
    cat <<EOF > docker/Dockerfile.backend
# Backend Dockerfile placeholder
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app ./app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
fi

if [ ! -f docker/Dockerfile.frontend ]; then
    cat <<EOF > docker/Dockerfile.frontend
# Frontend Dockerfile placeholder
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY ui ./ui
CMD ["streamlit", "run", "ui/streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]
EOF
fi

# ---------------------------------------------------------
# 7. Create .env.example if missing
# ---------------------------------------------------------
if [ ! -f .env.example ]; then
    cat <<EOF > .env.example
DATABASE_URL=postgresql://ctview:ctview@localhost:5432/ctview
API_BASE=http://localhost:8000
EOF
fi

echo "Cleanup complete."
echo "Your CTView project is now reorganised."
