#!/bin/bash

echo "=== CTView Diagnostics Script ==="
echo

PROJECT_ROOT="$(pwd)"

echo "1. Checking working directory..."
if [[ "$PROJECT_ROOT" == *"CTView" ]]; then
    echo "   ✔ Working directory OK: $PROJECT_ROOT"
else
    echo "   ✘ You are NOT in the CTView project root."
    echo "     Run: cd /Users/seyefarukie/PycharmProjects/CTView"
fi
echo

echo "2. Checking for app/ package..."
if [ -d "app" ]; then
    echo "   ✔ app/ folder exists"
else
    echo "   ✘ app/ folder missing — backend cannot run"
fi
echo

echo "3. Checking for __init__.py files..."
missing_init=0
for f in app app/api app/services app/repositories app/core app/db; do
    if [ ! -f "$f/__init__.py" ]; then
        echo "   ✘ Missing: $f/__init__.py"
        missing_init=1
    fi
done

if [ $missing_init -eq 0 ]; then
    echo "   ✔ All __init__.py files present"
fi
echo

echo "4. Checking for conflicting site-packages/app..."
if [ -d ".venv/lib/python3.14/site-packages/app" ]; then
    echo "   ✘ Conflicting package found: .venv/lib/python3.14/site-packages/app"
    echo "     Run: rm -rf .venv/lib/python3.14/site-packages/app"
else
    echo "   ✔ No conflicting app package in site-packages"
fi
echo

echo "5. Checking metrics service filename..."
if [ -f "app/services/metrics_service.py" ]; then
    echo "   ✔ metrics_service.py exists"
elif [ -f "app/services/metrics_services.py" ]; then
    echo "   ⚠ Found metrics_services.py (plural)"
    echo "     Rename to metrics_service.py for consistency:"
    echo "     mv app/services/metrics_services.py app/services/metrics_service.py"
else
    echo "   ✘ No metrics service file found"
fi
echo

echo "6. Checking Python import resolution..."
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

echo "7. Checking CSV file..."
if [ -f "data/survey/raw_survey_with_theme.csv" ]; then
    echo "   ✔ raw_survey_with_theme.csv found"
else
    echo "   ✘ raw_survey_with_theme.csv NOT found in data/survey/"
    echo "     Move it with:"
    echo "     mv raw_survey_with_theme.csv data/survey/"
fi
echo

echo "=== Diagnostics Complete ==="
