import { randomUUID } from "crypto";
import { pgTable, text, timestamp, uuid, boolean } from "drizzle-orm/pg-core";

export const user = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  email_verified: boolean("email_verified").default(false).notNull(),
  image: text("image"),
  created_at: timestamp("created_at").defaultNow().notNull(),
  updated_at: timestamp("updated_at")
    .$onUpdate(() => new Date())
    .notNull(),
});
