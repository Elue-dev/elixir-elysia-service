import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { db } from "./db";
import { openAPI } from "better-auth/plugins";
import { schema } from "@/lib/schema/index";
import { bearer } from "better-auth/plugins";
import { betterAuthFields } from "./schema/field-mappings";
import { jwtExpiresInSeconds } from "./token";

export const auth = betterAuth({
  basePath: "/api",
  trustedOrigins: ["http://localhost:3000"],
  plugins: [openAPI(), bearer()],
  emailAndPassword: {
    enabled: true,
    autoSignIn: true,
    password: {
      hash: (password: string) => Bun.password.hash(password),
      verify: async ({ password, hash }) => Bun.password.verify(password, hash),
    },
  },
  advanced: {
    database: {
      generateId: "uuid",
    },
  },
  database: drizzleAdapter(db, {
    provider: "pg",
    schema,
    camelCase: false,
  }),
  session: {
    ...betterAuthFields.session,
    expiresIn: jwtExpiresInSeconds,
    cookieCache: {
      enabled: true,
      maxAge: 60 * 5,
    },
  },
  user: betterAuthFields.user,
  account: betterAuthFields.account,
  verification: betterAuthFields.verification,
});
