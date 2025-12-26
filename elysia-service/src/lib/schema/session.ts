import { randomUUID } from "crypto";
import { pgTable, text, timestamp, index, uuid } from "drizzle-orm/pg-core";
import { user } from "./user";

export const session = pgTable(
  "sessions",
  {
    id: uuid("id").primaryKey().defaultRandom(),
    expires_at: timestamp("expires_at").notNull(),
    token: text("token").notNull().unique(),
    created_at: timestamp("created_at").defaultNow().notNull(),
    updated_at: timestamp("updated_at")
      .$onUpdate(() => new Date())
      .notNull(),
    ip_address: text("ip_address"),
    user_agent: text("user_agent"),
    user_id: uuid("user_id")
      .notNull()
      .references(() => user.id, { onDelete: "cascade" }),
  },
  (table) => [index("session_user_id_idx").on(table.user_id)],
);
