import openapi from "@elysiajs/openapi";
import { OpenAPI } from "./better-auth";

export const corsConfig = {
  origin: ["http://localhost:3000"],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  credentials: true,
  allowedHeaders: ["Content-Type", "Authorization"],
};

export const openapiConfig = openapi({
  path: "/docs",
  documentation: {
    info: {
      title: "Elysia Service API",
      version: "1.0.0",
      description: "API documentation",
    },
    components: await OpenAPI.components,
    paths: await OpenAPI.getPaths(),
  },
});
