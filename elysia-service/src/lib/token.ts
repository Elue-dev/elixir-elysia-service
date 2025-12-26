import jwt from "jsonwebtoken";
import ms from "ms";
import { env } from "@/config/env";

export const generateToken = (id: string) => {
  return jwt.sign({ sub: id }, env.JWT_SECRET as jwt.Secret, {
    expiresIn: env.JWT_EXPIRES as jwt.SignOptions["expiresIn"],
  });
};

export const jwtExpiresInMs = ms(env.JWT_EXPIRES as any);
export const jwtExpiresInSeconds = Math.floor(+jwtExpiresInMs / 1000);
