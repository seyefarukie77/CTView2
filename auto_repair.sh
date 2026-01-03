#!/bin/bash

echo "=== CTView Auto‑Repair Script ==="
echo

PROJECT_ROOT="$(pwd)"

echo "1. Ensuring we are in the CTView project root..."
if [[ "$PROJECT_ROOT" != *"CTView" ]]; then
    echo "   ✘ You are NOT in the CTView project root."
    echo "   Please run:"
    echo "      cd /Users/seyefarukie/PycharmProjects/CTView"
    exit 1
else
    echo "   ✔ Working directory OK: $PROJECT_ROOT"
fi
echo

echo "2. Creating missing __init__.py files..."
for f in app app/api app/services app/repositories app/core app/db; do
    if [ ! -f "$f/__init__.py" ]; then
        echo "   → Creating $f/__init__.py"
        touch "$f/__init__.py"
    else
        echo "   ✔ $f/__init__.py exists"
    fi
done
echo

echo "3. Removing conflicting site-packages/app if present..."
if [ -d ".venv/lib/python3.14/site-packages/app" ]; then
    echo "   → Removing conflicting package: .venv/lib/python3.14/site-packages/app"
    rm -rf .venv/lib/python3.14/site-packages/app
else
    echo "   ✔ No conflicting app package found"
fi
echo

echo "4. Fixing metrics service filename..."
if [ -f "app/services/metrics_services.py" ]; then
    echo "   → Renaming metrics_services.py → metrics_service.py"
    mv app/services/metrics_services.py app/services/metrics_service.py
elif [ -f "app/services/metrics_service.py" ]; then
    echo "   ✔ metrics_service.py already correct"
else
    echo "   ✘ No metrics service file found — backend will fail"
fi
echo

echo "5. Fixing import paths inside app/api/metrics.py..."
METRICS_FILE="app/api/metrics.py"
if grep -q "from services.metrics" "$METRICS_FILE"; then
    echo "   → Updating import to use full package path"
    sed -i '' 's/from services\./from app.services./g' "$METRICS_FILE"
fi

if grep -q "metrics_services" "$METRICS_FILE"; then
    echo "   → Updating import to metrics_service"
    sed -i '' 's/metrics_services/metrics_service/g' "$METRICS_FILE"
fi

echo "   ✔ Import path repaired"
echo

echo "6. Ensuring CSV exists in data/survey..."
if [ ! -d "data/survey" ]; then
    echo "   → Creating data/survey directory"
    mkdir -p data/survey
fi

if [ -f "raw_survey_theme.csv" ]; then
    echo "   → Moving raw_survey_theme.csv → data/survey/"
    mv raw_survey_theme.csv data/survey/
fi

if [ -f "data/survey/raw_survey_theme.csv" ]; then
    echo "   ✔ CSV found: data/survey/raw_survey_theme.csv"
else
    echo "   ✘ CSV missing — Streamlit will fail"
fi
echo

echo "7. Verifying Python can import app package..."
python3 - << 'EOF'
try:
    import app
    print("   ✔ Python can import app package:", app)
except Exception as e:
    print("   ✘ Python cannot import app package:", e)

try:
    import app.services.metrics_service as m
    print("   ✔ Python can import metrics_service:", m)
except Exception as e:
    print("   ⚠ Cannot import metrics_service:", e)
EOF
echo

echo "=== Auto‑Repair Complete ==="
echo "You can now run: ./run_all.sh"
