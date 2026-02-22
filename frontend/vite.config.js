import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 后端地址：前端代理会转发 API 请求到此，请先启动后端（端口 8082）
const BACKEND_TARGET = 'http://localhost:8082/api/v1'

const proxyOptions = {
  target: BACKEND_TARGET,
  changeOrigin: true,
  secure: false,
  ws: true,
  configure: (proxy) => {
    proxy.on('error', (err) => {
      const isRefused = err.code === 'ECONNREFUSED' ||
        (err.errors && err.errors.some(e => e && e.code === 'ECONNREFUSED'))
      if (isRefused) {
        console.warn(
          '\n[vite] 代理请求失败：后端未启动或未在 8082 端口监听。\n' +
          '请先在 backend 目录执行: mvn spring-boot:run\n'
        )
      }
    })
  }
}

const proxyPaths = ['/user', '/work', '/course', '/product', '/point', '/exchange', '/post', '/comment', '/file', '/order']

export default defineConfig({
  base: './',
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    port: 3003,
    host: true,
    proxy: Object.fromEntries(proxyPaths.map(path => [path, { ...proxyOptions }]))
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
