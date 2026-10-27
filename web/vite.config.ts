import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [tailwindcss()],
  // Repo-root .env (the same file Compose reads) supplies the header credit.
  envDir: "..",
  // Set BASE_PATH=/<repo>/ when deploying to a GitHub Pages project site;
  // asset URLs (including the vendored MediaPipe files) are resolved
  // against it via import.meta.env.BASE_URL.
  base: process.env.BASE_PATH ?? "/",
  build: {
    target: "es2022",
    chunkSizeWarningLimit: 3000, // three + rapier + mediapipe are heavy
  },
});
