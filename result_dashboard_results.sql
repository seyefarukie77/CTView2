-- Dashboard metric results (cached aggregates, snapshots, etc.)
CREATE TABLE IF NOT EXISTS dashboard_results (
    id SERIAL PRIMARY KEY,
    dashboard_name TEXT NOT NULL,
    result_type TEXT NOT NULL,          -- e.g. 'yoy', 'sentiment_summary'
    result_json JSONB NOT NULL,
    valid_from TIMESTAMP DEFAULT NOW(), -- when this result became valid
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dashboard_results_name_type
    ON dashboard_results (dashboard_name, result_type);

-- User dashboard configurations (saved layouts, filters, charts)
CREATE TABLE IF NOT EXISTS dashboard_configs (
    id SERIAL PRIMARY KEY,
    user_id TEXT NOT NULL,
    dashboard_name TEXT NOT NULL,
    config_json JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dashboard_configs_user_name
    ON dashboard_configs (user_id, dashboard_name);

-- Optional: job registry for cache refresh tracking
CREATE TABLE IF NOT EXISTS metric_cache_jobs (
    id SERIAL PRIMARY KEY,
    job_name TEXT NOT NULL,
    last_run_at TIMESTAMP,
    status TEXT,                        -- 'success', 'failed', 'running'
    message TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
