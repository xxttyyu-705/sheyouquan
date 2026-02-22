import axios from 'axios';
import { ElMessage } from 'element-plus';
import router from '../router'; // 导入 router
import { useUserStore } from '../stores/user';

// 创建 Axios 实例
const service = axios.create({
  baseURL: '', // 基础 URL，vite.config.js 中的 proxy 会处理
  timeout: 10000, // 请求超时时间
  withCredentials: true, // 允许跨域携带 cookie
});

// 请求拦截器：添加 Token
service.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    console.error('请求拦截器错误：', error);
    return Promise.reject(error);
  }
);

// 响应拦截器：处理 401 错误
service.interceptors.response.use(
  (response) => {
    // 后端返回的 code 不为 200 也可能是一种业务错误，这里可以根据实际情况处理
    // 为简化，我们只透传后端返回的数据
    return response;
  },
  (error) => {
    if (error.response) {
      const { status, data } = error.response;
      if (status === 401) {
        // 避免重复弹出提示
        if (router.currentRoute.value.path !== '/login') {
          ElMessage.error(data.message || '登录状态已过期，请重新登录');
          // 同步清除 Pinia 与 localStorage 的登录信息
          useUserStore().logout();
          // 跳转到登录页
          router.push('/login');
        }
      } else {
        // 其他 HTTP 错误
        ElMessage.error(data.message || '请求失败，请稍后重试');
      }
    } else if (!error.response) {
      // 网络错误，例如：超时、断网等
      ElMessage.error('网络连接异常，请检查您的网络');
    }
    return Promise.reject(error);
  }
);

export default service;
