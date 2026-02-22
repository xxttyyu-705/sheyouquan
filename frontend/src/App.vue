<template>
  <div id="app">
    <el-container v-if="showLayout" class="layout-container">
      <el-header class="header">
        <div class="header-content">
          <div class="logo" @click="router.push('/')">
            <el-icon size="24"><Camera /></el-icon>
            <span>摄友圈</span>
          </div>
          <el-menu
            :default-active="route.path"
            mode="horizontal"
            router
            class="nav-menu"
          >
            <el-menu-item index="/">首页</el-menu-item>
            <el-menu-item index="/works">作品</el-menu-item>
            <el-menu-item index="/courses">课程</el-menu-item>
            <el-menu-item index="/mall">商城</el-menu-item>
            <el-menu-item index="/community">社区</el-menu-item>
            <el-menu-item v-if="isAdmin" index="/admin">管理</el-menu-item>
          </el-menu>
          <div class="user-info">
            <template v-if="isLoggedIn && user">
              <el-dropdown @command="handleCommand">
                <span class="user-dropdown">
                  <el-avatar :size="32" :src="user.avatar">
                    {{ user.nickname?.charAt(0) || user.username?.charAt(0) }}
                  </el-avatar>
                  <span class="username">{{ user.nickname || user.username }}</span>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                    <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </template>
            <template v-else>
              <el-button type="primary" plain @click="router.push('/login')">登录/注册</el-button>
            </template>
          </div>
        </div>
      </el-header>
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
    <router-view v-else />
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useUserStore } from '@/stores/user';
import { Camera } from '@element-plus/icons-vue';

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

// 在应用加载时尝试从 localStorage 恢复登录状态到 Pinia
onMounted(() => {
  userStore.checkLoginStatus();
});

const showLayout = computed(() => {
  const noLayoutRoutes = ['/login', '/register'];
  return !noLayoutRoutes.includes(route.path);
});

// 从 Pinia store 获取用户状态
const user = computed(() => userStore.user);
const isLoggedIn = computed(() => userStore.isLoggedIn);
const isAdmin = computed(() => userStore.isAdmin);

const handleCommand = (command) => {
  if (command === 'profile') {
    router.push('/profile');
  } else if (command === 'logout') {
    userStore.logout();
    router.push('/login');
  }
};
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
}

.header {
  background: #fff;
  border-bottom: 1px solid #e4e7ed;
  padding: 0;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  font-weight: bold;
  color: #409eff;
  cursor: pointer;
}

.nav-menu {
  border: none;
  flex: 1;
  margin: 0 20px;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 0 10px;
}

.username {
  font-size: 14px;
  color: #606266;
}

.main-content {
  background: #f5f7fa;
  padding: 20px;
}
</style>
