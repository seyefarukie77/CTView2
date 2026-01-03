# CTView

CTView is an end-to-end colleague feedback analytics tool that ingests survey data, applies theme mapping and sentiment analysis, and exposes insights through a backend API and an interactive Streamlit dashboard.

## Features

- 🔄 End-to-end pipeline: CSV/Excel → DB → API → Dashboard  
- 🧩 Theme-based analysis with multi-theme support per response  
- 📈 Year-on-Year trend metrics (per theme)  
- 😊 Sentiment distribution and verbatim explorer  
- 🌥️ Word cloud of comments  
- 🧪 Tested, modular backend (repositories, services, API layers)

---

## Project structure

```bash

CTView/
├── legacy/
│   ├── models/
│   ├── services/
│   └── old_scripts/
├── app/
│   ├── api/
│   │   ├── __init__.py
│   │   └── analytics.py          # single canonical router
│   ├── core/
│   │   ├── __init__.py
│   │   └── config.py
│   ├── db/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── dbconn.py
│   │   ├── migrations/
│   │   └── session.py            # (if you keep SQLAlchemy)
│   ├── models/
│   │   ├── __init__.py
│   │   └── survey.py
│   ├── preprocessing/
│   │   ├── __init__.py
│   │   └── theme_mapper.py
│   ├── repositories/
│   │   ├── __init__.py
│   │   ├── responses_repo.py
│   │   └── surveys_repo.py
│   ├── schema/
│   │   ├── __init__.py
│   │   └── survey.py
│   └── services/
│       ├── __init__.py
│       ├── csv_import_service.py
│       └── metrics_service.py
├── data/
│   ├── scripts/                  # ingestion, raw psycopg2 allowed
│   └── survey/
└── ui/
    ├── api.py
    └── streamlit_app.py






Endpoint	Description
/metrics/yoy-engagement	YoY engagement trend
/metrics/sentiment	Sentiment distribution
/metrics/themes	Theme distribution
/metrics/theme-sentiment	Theme × sentiment matrix
/metrics/engagement-by-dimension	Department/location/role breakdown
/metrics/verbatim	Filtered verbatim comments