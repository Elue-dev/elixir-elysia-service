import { Elysia } from "elysia";
import { cors } from "@elysiajs/cors";
import { corsConfig, openapiConfig } from "@/config";
import { betterAuthConfig } from "./config/better-auth";

const app = new Elysia()
  .use(openapiConfig)
  .use(betterAuthConfig)
  .use(cors(corsConfig))
  .get("/ping", () => "pong")
  .listen(8080);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`,
);
