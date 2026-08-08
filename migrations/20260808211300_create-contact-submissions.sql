-- Contact form submissions from the public "Let's Talk" form.
-- No SELECT policy/grant is defined for anon or authenticated: rows are
-- only readable via the admin-submissions edge function, which uses the
-- project API key (bypasses RLS) after checking the admin password.

CREATE TABLE contact_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  company TEXT,
  email TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anyone_can_submit_contact_form" ON contact_submissions
  FOR INSERT TO anon, authenticated
  WITH CHECK (true);

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT INSERT ON contact_submissions TO anon, authenticated;
