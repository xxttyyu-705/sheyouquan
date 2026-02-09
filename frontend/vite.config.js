import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  base: './',
  plugins: [vue()],
  server: {
    port: 3003,
    host: true,
    proxy: {
      '/user': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/work': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/course': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/product': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/point': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/exchange': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/post': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/comment': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      },
      '/order': {
        target: 'http://localhost:8082/api/v1',
        changeOrigin: true,
        secure: false,
        ws: true
      }
    }
  },
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: {
        main: './index.html'
      }
    }
  }
})
