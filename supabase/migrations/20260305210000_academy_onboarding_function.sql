-- academy onboarding 절차
-- 목표: academies + academy_members(owner)를 한 트랜잭션에서 안전하게 upsert
-- 근거:
-- - data-upsert: INSERT ... ON CONFLICT로 경쟁 상태 없이 원자적 처리
-- - lock-short-transactions: 외부 호출 없이 최소 범위 DML만 수행

create or replace function public.onboard_academy_owner(
  p_owner_user_id uuid,
  p_academy_name text,
  p_academy_id uuid default gen_random_uuid()
)
returns uuid
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_actor_user_id uuid;
  v_academy_name text;
begin
  v_actor_user_id := (select auth.uid());
  v_academy_name := nullif(trim(p_academy_name), '');

  if p_owner_user_id is null then
    raise exception 'owner user id is required';
  end if;

  if v_academy_name is null then
    raise exception 'academy name is required';
  end if;

  -- 일반 authenticated 컨텍스트에서는 owner user id 위임을 허용하지 않는다.
  if v_actor_user_id is not null and p_owner_user_id <> v_actor_user_id then
    raise exception 'owner user id must match auth.uid()';
  end if;

  insert into public.academies (id, name)
  values (p_academy_id, v_academy_name)
  on conflict (id)
  do nothing;

  insert into public.academy_members (academy_id, user_id, role)
  values (p_academy_id, p_owner_user_id, 'owner')
  on conflict (academy_id, user_id)
  do nothing;

  return p_academy_id;
end;
$$;
