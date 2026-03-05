create extension if not exists pgcrypto;

create table if not exists public.academies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.academy_members (
  academy_id uuid not null references public.academies(id) on delete cascade,
  user_id uuid not null,
  role text not null default 'staff',
  created_at timestamptz not null default now(),
  primary key (academy_id, user_id),
  constraint academy_members_role_check check (role in ('owner', 'manager', 'staff'))
);

create table if not exists public.academy_enrollments (
  id bigint generated always as identity primary key,
  academy_id uuid not null references public.academies(id) on delete cascade,
  student_name text not null,
  student_phone text null,
  created_by uuid not null,
  created_at timestamptz not null default now(),
  constraint academy_enrollments_student_name_check check (length(trim(student_name)) > 0)
);

-- query-missing-indexes / schema-foreign-key-indexes
create index if not exists academy_members_user_id_idx on public.academy_members (user_id);
create index if not exists academy_enrollments_academy_id_id_idx on public.academy_enrollments (academy_id, id);
create index if not exists academy_enrollments_created_by_idx on public.academy_enrollments (created_by);

-- security-rls-basics
alter table public.academy_members enable row level security;
alter table public.academy_members force row level security;
alter table public.academy_enrollments enable row level security;
alter table public.academy_enrollments force row level security;

drop policy if exists academy_members_select_own on public.academy_members;
create policy academy_members_select_own
on public.academy_members
for select
to authenticated
using (user_id = (select auth.uid()));

drop policy if exists academy_enrollments_select_by_membership on public.academy_enrollments;
create policy academy_enrollments_select_by_membership
on public.academy_enrollments
for select
to authenticated
using (
  exists (
    select 1
    from public.academy_members as am
    where am.academy_id = academy_enrollments.academy_id
      and am.user_id = (select auth.uid())
  )
);

drop policy if exists academy_enrollments_insert_by_membership on public.academy_enrollments;
create policy academy_enrollments_insert_by_membership
on public.academy_enrollments
for insert
to authenticated
with check (
  created_by = (select auth.uid())
  and exists (
    select 1
    from public.academy_members as am
    where am.academy_id = academy_enrollments.academy_id
      and am.user_id = (select auth.uid())
  )
);
