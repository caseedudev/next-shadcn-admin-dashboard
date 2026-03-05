import { NextResponse } from "next/server";

import { z } from "zod";

import { createSupabaseServerClient } from "@/lib/supabase/server";

const listEnrollmentsQuerySchema = z.object({
  academyId: z.string().uuid(),
  cursor: z.coerce.number().int().positive().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

const createEnrollmentBodySchema = z.object({
  academyId: z.string().uuid(),
  studentName: z.string().trim().min(1).max(80),
  studentPhone: z.string().trim().min(7).max(20).optional(),
});

function badRequest(message: string) {
  return NextResponse.json({ success: false, error: message }, { status: 400 });
}

function unauthorized() {
  return NextResponse.json({ success: false, error: "Unauthorized" }, { status: 401 });
}

export async function GET(request: Request) {
  try {
    const searchParams = new URL(request.url).searchParams;
    const parsedQuery = listEnrollmentsQuerySchema.safeParse({
      academyId: searchParams.get("academyId") ?? undefined,
      cursor: searchParams.get("cursor") ?? undefined,
      limit: searchParams.get("limit") ?? undefined,
    });

    if (!parsedQuery.success) {
      return badRequest(parsedQuery.error.issues[0]?.message ?? "잘못된 요청입니다.");
    }

    const { academyId, cursor, limit } = parsedQuery.data;
    const supabase = await createSupabaseServerClient();

    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return unauthorized();
    }

    let query = supabase
      .from("academy_enrollments")
      .select("id, academy_id, student_name, student_phone, created_by, created_at")
      .eq("academy_id", academyId)
      .order("id", { ascending: true })
      .limit(limit + 1);

    if (cursor) {
      query = query.gt("id", cursor);
    }

    const { data, error } = await query;

    if (error) {
      return NextResponse.json({ success: false, error: "수강 등록 목록 조회에 실패했습니다." }, { status: 500 });
    }

    const rows = data ?? [];
    const hasNext = rows.length > limit;
    const items = hasNext ? rows.slice(0, limit) : rows;
    const nextCursor = hasNext ? (items[items.length - 1]?.id ?? null) : null;

    return NextResponse.json({
      success: true,
      items,
      pagination: {
        limit,
        nextCursor,
      },
    });
  } catch {
    return NextResponse.json({ success: false, error: "서버 오류가 발생했습니다." }, { status: 500 });
  }
}

export async function POST(request: Request) {
  try {
    const parsedBody = createEnrollmentBodySchema.safeParse(await request.json());
    if (!parsedBody.success) {
      return badRequest(parsedBody.error.issues[0]?.message ?? "잘못된 요청입니다.");
    }

    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return unauthorized();
    }

    const { academyId, studentName, studentPhone } = parsedBody.data;

    const { data, error } = await supabase
      .from("academy_enrollments")
      .insert({
        academy_id: academyId,
        student_name: studentName,
        student_phone: studentPhone ?? null,
        created_by: user.id,
      })
      .select("id, academy_id, student_name, student_phone, created_by, created_at")
      .single();

    if (error) {
      return NextResponse.json({ success: false, error: "수강 등록 생성에 실패했습니다." }, { status: 500 });
    }

    return NextResponse.json({ success: true, item: data }, { status: 201 });
  } catch {
    return NextResponse.json({ success: false, error: "서버 오류가 발생했습니다." }, { status: 500 });
  }
}
