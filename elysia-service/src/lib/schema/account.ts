import { pgTable, text, timestamp, index, uuid } from "drizzle-orm/pg-core";
import { user } from "./user";

export const account = pgTable(
  "accounts",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    account_id: text("account_id").notNull(),
    provider_id: text("provider_id").notNull(),
    user_id: uuid("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
    access_token: text("access_token"),
    refresh_token: text("refresh_token"),
    id_token: text("id_token"),
    access_token_expires_at: timestamp("access_token_expires_at"),
    refresh_token_expires_at: timestamp("refresh_token_expires_at"),
    scope: text("scope"),
    password: text("password"),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at")
      .$onUpdate(() => new Date())
      .notNull(),
  },
  (table) => [index("account_user_id_idx").on(table.user_id)],
);
