#!/bin/bash

echo "=== Moving CSV files into data/survey/ ==="

TARGET_DIR="data/survey"

mkdir -p "$TARGET_DIR"

# Find all CSVs except those already in data/survey
find . -type f -name "*.csv" ! -path "./data/survey/*" | while read file; do
    echo "Moving $file → $TARGET_DIR/"
    mv "$file" "$TARGET_DIR/"
done
#!/bin/bash

echo "=== Moving raw_survey_theme.csv into data/survey/ ==="

TARGET_DIR="data/survey"

mkdir -p "$TARGET_DIR"

if [ -f "raw_survey_theme.csv" ]; then
    echo "Moving raw_survey_theme.csv → $TARGET_DIR/"
    mv raw_survey_theme.csv "$TARGET_DIR/"
else
    echo "raw_survey_theme.csv not found in project root."
fi

echo "Done."

echo "Done."
