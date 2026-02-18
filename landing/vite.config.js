import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  // GitHub Pages project site: https://<user>.github.io/<repo>/
  // Ensure assets resolve under /shoresafe/
  base: '/shoresafe/',
  plugins: [react()],
})
