export * from "./account";
export * from "./session";
export * from "./user";
export * from "./verification";

import { account } from "./account";
import { session } from "./session";
import { user } from "./user";
import { verification } from "./verification";

export const schema = {
  user,
  verification,
  session,
  account,
};
