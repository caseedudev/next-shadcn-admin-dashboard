import { NextResponse } from "next/server";

import { z } from "zod";

import { createSupabaseServerClient } from "@/lib/supabase/server";

const registerBodySchema = z
  .object({
    email: z.string().email(),
    password: z.string().min(6),
    confirmPassword: z.string().min(6),
  })
  .refine((value) => value.password === value.confirmPassword, {
    path: ["confirmPassword"],
    message: "비밀번호가 일치하지 않습니다.",
  });

function badRequest(message: string) {
  return NextResponse.json({ success: false, error: message }, { status: 400 });
}

export async function POST(request: Request) {
  const bodyPromise = request.json();
  const supabasePromise = createSupabaseServerClient();

  try {
    const rawBody = await bodyPromise;
    const parsedBody = registerBodySchema.safeParse(rawBody);

    if (!parsedBody.success) {
      return badRequest(parsedBody.error.issues[0]?.message ?? "잘못된 요청입니다.");
    }

    const supabase = await supabasePromise;
    const { email, password } = parsedBody.data;

    const {
      data: { user, session },
      error,
    } = await supabase.auth.signUp({
      email,
      password,
    });

    if (error) {
      return NextResponse.json({ success: false, error: error.message }, { status: 400 });
    }

    return NextResponse.json(
      {
        success: true,
        requiresEmailVerification: !session,
        user: user
          ? {
              id: user.id,
              email: user.email,
            }
          : null,
      },
      { status: 201 },
    );
  } catch {
    return NextResponse.json({ success: false, error: "서버 오류가 발생했습니다." }, { status: 500 });
  }
}
