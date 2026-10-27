FROM node:22-bookworm-slim AS build

WORKDIR /src/web

RUN npm install -g pnpm@11

COPY web/package.json web/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY web/ ./
# Values come from Compose, which reads the repo .env. No names are baked in here.
ARG VITE_STUDENT_NAME
ARG VITE_STUDENT_NUMBER
ENV VITE_STUDENT_NAME=$VITE_STUDENT_NAME
ENV VITE_STUDENT_NUMBER=$VITE_STUDENT_NUMBER
RUN pnpm build

FROM nginx:1.27-alpine

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/web/dist /usr/share/nginx/html

EXPOSE 8080
