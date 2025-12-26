import { env } from "@/config/env";
import jwt from "jsonwebtoken";

export const generateToken = (id: string) => {
  return jwt.sign({ sub: id }, env.JWT_SECRET as jwt.Secret, {
    expiresIn: env.JWT_EXPIRES as jwt.SignOptions["expiresIn"],
  });
};
