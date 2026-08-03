-- =============================================
-- Supabase Setup - Portfolio Visitor Tracker + CMS
-- Chạy trong SQL Editor 1 lần duy nhất
-- =============================================

-- ========== VISITOR TRACKING ==========

CREATE TABLE IF NOT EXISTS visitors (
  id BIGSERIAL PRIMARY KEY,
  session_id TEXT,
  ip TEXT,
  country TEXT,
  city TEXT,
  region TEXT,
  timezone TEXT,
  browser TEXT,
  os TEXT,
  device_type TEXT DEFAULT 'desktop',
  screen_width INTEGER,
  screen_height INTEGER,
  language TEXT,
  referrer TEXT,
  page_url TEXT,
  user_agent TEXT,
  visited_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS page_views (
  id BIGSERIAL PRIMARY KEY,
  session_id TEXT,
  page_url TEXT,
  page_title TEXT,
  time_spent INTEGER DEFAULT 0,
  viewed_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========== ADMIN AUTH ==========

CREATE TABLE IF NOT EXISTS admin_config (
  id INTEGER PRIMARY KEY DEFAULT 1,
  username TEXT NOT NULL DEFAULT 'admin',
  password_hash TEXT NOT NULL
);

-- Default: admin / admin
INSERT INTO admin_config (id, username, password_hash)
VALUES (1, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918')
ON CONFLICT (id) DO NOTHING;

-- ========== CMS: HIGHLIGHTS ==========

CREATE TABLE IF NOT EXISTS highlights (
  id BIGSERIAL PRIMARY KEY,
  sort_order INTEGER DEFAULT 0,
  title TEXT NOT NULL,
  "desc" TEXT,
  detail TEXT,
  image TEXT,
  video TEXT,
  tech TEXT[] DEFAULT '{}',
  play_store TEXT,
  app_store TEXT,
  playable BOOLEAN DEFAULT false,
  playable_files TEXT[] DEFAULT '{}',
  duration_from TEXT,
  duration_to TEXT,
  role TEXT,
  impacts JSONB DEFAULT '[]',
  hypotheses JSONB DEFAULT '[]',
  metrics JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========== CMS: PROJECT CATEGORIES ==========

CREATE TABLE IF NOT EXISTS project_categories (
  id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0
);

-- ========== CMS: PROJECTS ==========

CREATE TABLE IF NOT EXISTS projects (
  id BIGSERIAL PRIMARY KEY,
  category_id TEXT REFERENCES project_categories(id) ON DELETE CASCADE,
  sort_order INTEGER DEFAULT 0,
  title TEXT NOT NULL,
  "desc" TEXT,
  detail TEXT,
  image TEXT,
  video TEXT,
  tech TEXT[] DEFAULT '{}',
  play_store TEXT,
  app_store TEXT,
  playable BOOLEAN DEFAULT false,
  playable_files TEXT[] DEFAULT '{}',
  duration_from TEXT,
  duration_to TEXT,
  role TEXT,
  impacts JSONB DEFAULT '[]',
  hypotheses JSONB DEFAULT '[]',
  metrics JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========== CMS: TIMELINE ==========

CREATE TABLE IF NOT EXISTS timeline (
  id BIGSERIAL PRIMARY KEY,
  sort_order INTEGER DEFAULT 0,
  period TEXT NOT NULL,
  role TEXT NOT NULL,
  company TEXT,
  "desc" TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========== RLS ==========

ALTER TABLE visitors ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE highlights ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE timeline ENABLE ROW LEVEL SECURITY;

-- Drop old policies
DO $$ 
DECLARE
  tbl TEXT;
  pol RECORD;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY['visitors','page_views','admin_config','highlights','project_categories','projects','timeline'])
  LOOP
    FOR pol IN SELECT policyname FROM pg_policies WHERE tablename = tbl
    LOOP
      EXECUTE format('DROP POLICY IF EXISTS %I ON %I', pol.policyname, tbl);
    END LOOP;
  END LOOP;
END $$;

-- Visitors: anon insert + select
CREATE POLICY "anon_insert_visitors" ON visitors FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_select_visitors" ON visitors FOR SELECT TO anon USING (true);

-- Page views: anon insert + select
CREATE POLICY "anon_insert_page_views" ON page_views FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_select_page_views" ON page_views FOR SELECT TO anon USING (true);

-- Admin config: anon select only
CREATE POLICY "anon_select_admin_config" ON admin_config FOR SELECT TO anon USING (true);

-- CMS tables: anon full access (auth handled by dashboard login)
CREATE POLICY "anon_all_highlights" ON highlights FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_project_categories" ON project_categories FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_projects" ON projects FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "anon_all_timeline" ON timeline FOR ALL TO anon USING (true) WITH CHECK (true);

-- ========== GRANTS ==========

GRANT SELECT, INSERT ON visitors TO anon;
GRANT SELECT, INSERT ON page_views TO anon;
GRANT SELECT ON admin_config TO anon;
GRANT ALL ON highlights TO anon;
GRANT ALL ON project_categories TO anon;
GRANT ALL ON projects TO anon;
GRANT ALL ON timeline TO anon;
GRANT USAGE, SELECT ON SEQUENCE visitors_id_seq TO anon;
GRANT USAGE, SELECT ON SEQUENCE page_views_id_seq TO anon;
GRANT USAGE, SELECT ON SEQUENCE highlights_id_seq TO anon;
GRANT USAGE, SELECT ON SEQUENCE projects_id_seq TO anon;
GRANT USAGE, SELECT ON SEQUENCE timeline_id_seq TO anon;

-- ========== INDEXES ==========

CREATE INDEX IF NOT EXISTS idx_visitors_visited_at ON visitors (visited_at DESC);
CREATE INDEX IF NOT EXISTS idx_projects_category ON projects (category_id);
CREATE INDEX IF NOT EXISTS idx_highlights_sort ON highlights (sort_order);
CREATE INDEX IF NOT EXISTS idx_projects_sort ON projects (sort_order);
CREATE INDEX IF NOT EXISTS idx_timeline_sort ON timeline (sort_order);

-- =============================================
-- XONG! Sau khi chạy SQL, vào:
--   Integrations → Data API → expose tất cả bảng mới
-- =============================================
