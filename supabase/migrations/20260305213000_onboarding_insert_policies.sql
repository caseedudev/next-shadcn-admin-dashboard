-- 온보딩 경로의 RLS insert 정책 보강
-- 목적:
-- 1) authenticated 사용자가 academies를 생성할 수 있게 허용
-- 2) academy_members owner self-insert만 허용(기존 academy 탈취 방지)

DROP POLICY IF EXISTS academies_insert_authenticated ON public.academies;
CREATE POLICY academies_insert_authenticated
ON public.academies
FOR INSERT
TO authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS academy_members_insert_self_owner ON public.academy_members;
CREATE POLICY academy_members_insert_self_owner
ON public.academy_members
FOR INSERT
TO authenticated
WITH CHECK (
  user_id = (SELECT auth.uid())
  AND role = 'owner'
  AND NOT EXISTS (
    SELECT 1
    FROM public.academy_members AS am
    WHERE am.academy_id = academy_members.academy_id
  )
);
