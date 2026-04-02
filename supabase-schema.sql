-- Run this in Supabase: SQL Editor → New query → paste → Run

create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  match_date date not null,
  match_time text not null,
  note text default '' not null,
  player_name text default '' not null,
  created_at timestamptz not null default now()
);

alter table public.matches enable row level security;

-- Anonymous clients (browser) can read/write/delete. The anon key is still a secret:
-- keep config.js out of public repos, or use host env vars at deploy time.
create policy "matches_select_anon" on public.matches
  for select to anon using (true);

create policy "matches_insert_anon" on public.matches
  for insert to anon with check (true);

create policy "matches_delete_anon" on public.matches
  for delete to anon using (true);

-- Realtime: so other devices see new matches without refresh
alter publication supabase_realtime add table public.matches;
