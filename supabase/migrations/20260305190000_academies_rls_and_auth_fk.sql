-- supabase-postgres-best-practices 적용
-- 1) schema-foreign-key-indexes: membership/enrollment 사용자 컬럼을 auth.users FK로 연결
-- 2) security-rls-basics: academies 테이블에도 RLS + FORCE RLS 적용
-- 3) security-rls-performance: 정책 내부 auth.uid() 호출을 (select auth.uid()) 형태로 사용

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'academy_members_user_id_fkey'
  ) THEN
    ALTER TABLE public.academy_members
      ADD CONSTRAINT academy_members_user_id_fkey
      FOREIGN KEY (user_id)
      REFERENCES auth.users(id)
      ON DELETE CASCADE;
  END IF;
END
$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'academy_enrollments_created_by_fkey'
  ) THEN
    ALTER TABLE public.academy_enrollments
      ADD CONSTRAINT academy_enrollments_created_by_fkey
      FOREIGN KEY (created_by)
      REFERENCES auth.users(id)
      ON DELETE CASCADE;
  END IF;
END
$$;

ALTER TABLE public.academies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academies FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS academies_select_by_membership ON public.academies;
CREATE POLICY academies_select_by_membership
ON public.academies
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1
    FROM public.academy_members AS am
    WHERE am.academy_id = academies.id
      AND am.user_id = (SELECT auth.uid())
  )
);
