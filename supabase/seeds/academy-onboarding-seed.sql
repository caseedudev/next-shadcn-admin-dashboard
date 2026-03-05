-- academy onboarding idempotent seed (local/staging)
-- 실행 전제: auth.users에 아래 owner_email 계정이 존재해야 함
-- 반복 실행 안전성:
-- - 고정 academy_id 사용
-- - public.onboard_academy_owner 내부 INSERT ... ON CONFLICT UPSERT 사용

do $$
declare
  v_missing_emails text;
begin
  with seed_rows as (
    select *
    from (
      values
        ('owner+seoul@example.com'::text),
        ('owner+busan@example.com'::text)
    ) as t(owner_email)
  )
  select string_agg(s.owner_email, ', ' order by s.owner_email)
  into v_missing_emails
  from seed_rows as s
  left join auth.users as u
    on lower(u.email) = lower(s.owner_email)
  where u.id is null;

  if v_missing_emails is not null then
    raise exception 'Missing auth.users seed owner emails: %', v_missing_emails;
  end if;
end
$$;

with seed_rows as (
  select *
  from (
    values
      (
        '11111111-1111-1111-1111-111111111111'::uuid,
        'Demo Academy Seoul'::text,
        'owner+seoul@example.com'::text
      ),
      (
        '22222222-2222-2222-2222-222222222222'::uuid,
        'Demo Academy Busan'::text,
        'owner+busan@example.com'::text
      )
  ) as t(academy_id, academy_name, owner_email)
),
resolved_owners as (
  select
    s.academy_id,
    s.academy_name,
    s.owner_email,
    u.id as owner_user_id
  from seed_rows as s
  left join auth.users as u
    on lower(u.email) = lower(s.owner_email)
)
select public.onboard_academy_owner(
  p_owner_user_id := r.owner_user_id,
  p_academy_name := r.academy_name,
  p_academy_id := r.academy_id
)
from resolved_owners as r
where r.owner_user_id is not null;
