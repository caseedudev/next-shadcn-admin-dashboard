import { NextResponse } from "next/server";

import { z } from "zod";

import { createSupabaseServerClient } from "@/lib/supabase/server";

const loginBodySchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

function badRequest(message: string) {
  return NextResponse.json({ success: false, error: message }, { status: 400 });
}

function unauthorized(message: string) {
  return NextResponse.json({ success: false, error: message }, { status: 401 });
}

export async function POST(request: Request) {
  const bodyPromise = request.json();
  const supabasePromise = createSupabaseServerClient();

  try {
    const rawBody = await bodyPromise;
    const parsedBody = loginBodySchema.safeParse(rawBody);

    if (!parsedBody.success) {
      return badRequest(parsedBody.error.issues[0]?.message ?? "잘못된 요청입니다.");
    }

    const supabase = await supabasePromise;
    const { email, password } = parsedBody.data;

    const {
      data: { user },
      error,
    } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error || !user) {
      return unauthorized("이메일 또는 비밀번호가 올바르지 않습니다.");
    }

    return NextResponse.json(
      {
        success: true,
        user: {
          id: user.id,
          email: user.email,
        },
      },
      { status: 200 },
    );
  } catch {
    return NextResponse.json({ success: false, error: "서버 오류가 발생했습니다." }, { status: 500 });
  }
}
