-- Admin workflow: status, archiving, and an appendable notes log per submission.
-- No RLS policies are added for anon/authenticated on the new columns or the
-- notes table — writes/reads for these stay behind the admin-submissions
-- edge function, which uses the project API key (bypasses RLS).

ALTER TABLE contact_submissions
  ADD COLUMN status TEXT NOT NULL DEFAULT 'new'
    CHECK (status IN ('new', 'contacted', 'qualified', 'won', 'lost')),
  ADD COLUMN archived BOOLEAN NOT NULL DEFAULT false;

CREATE INDEX idx_contact_submissions_archived ON contact_submissions(archived);

CREATE TABLE contact_submission_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submission_id UUID NOT NULL REFERENCES contact_submissions(id) ON DELETE CASCADE,
  note TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_contact_submission_notes_submission_id ON contact_submission_notes(submission_id);

ALTER TABLE contact_submission_notes ENABLE ROW LEVEL SECURITY;
