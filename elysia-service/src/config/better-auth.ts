import { Elysia } from "elysia";
import { auth } from "@/lib/auth";
import { generateToken } from "@/lib/token";

export const betterAuthConfig = new Elysia({ name: "better-auth" })
  .mount("/auth", auth.handler)
  .macro({
    auth: {
      async resolve({ status, request: { headers } }) {
        const session = await auth.api.getSession({
          headers,
        });

        if (!session) return status(401);

        return {
          user: session.user,
          session: session.session,
        };
      },
    },
  })
  // i am overriding this so i can add a jwt token
  .post("/auth/api/sign-in/email", async ({ body }) => {
    const { email, password } = body as { email: string; password: string };
    const res = await auth.api.signInEmail({
      body: {
        email,
        password,
      },
    });

    return {
      user: {
        id: res.user.id,
        name: res.user.name,
        email: res.user.email,
        image: res.user.image,
        email_verified: res.user.emailVerified,
        created_at: res.user.createdAt,
        updated_at: res.user.updatedAt,
      },
      access_token: generateToken(res.user.id),
    };
  });

let _schema: ReturnType<typeof auth.api.generateOpenAPISchema>;
const getSchema = async () => (_schema ??= auth.api.generateOpenAPISchema());

export const OpenAPI = {
  getPaths: (prefix = "/auth/api") =>
    getSchema().then(({ paths }) => {
      const reference: typeof paths = Object.create(null);

      for (const path of Object.keys(paths)) {
        const pathItem = paths[path];

        if (!pathItem) continue;

        const key = prefix + path;
        reference[key] = pathItem;

        for (const method of Object.keys(pathItem)) {
          const operation = (reference[key] as any)[method];
          operation.tags = ["Better Auth"];
        }
      }

      return reference;
    }) as Promise<any>,
  components: getSchema().then(({ components }) => components) as Promise<any>,
} as const;
