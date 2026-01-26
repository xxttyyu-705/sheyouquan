import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: '',
    username: '',
    userId: null,
    isLoggedIn: false
  }),
  actions: {
    // 设置用户信息
    setUserInfo(userInfo) {
      this.token = userInfo.token || ''
      this.username = userInfo.username || ''
      this.userId = userInfo.userId || null
      this.isLoggedIn = true
    },
    
    // 清除用户信息
    clearUserInfo() {
      this.token = ''
      this.username = ''
      this.userId = null
      this.isLoggedIn = false
    },
    
    // 检查登录状态
    checkLoginStatus() {
      const token = localStorage.getItem('token')
      const username = localStorage.getItem('username')
      const userId = localStorage.getItem('userId')
      
      if (token && username && userId) {
        this.token = token
        this.username = username
        this.userId = parseInt(userId)
        this.isLoggedIn = true
        return true
      }
      return false
    },
    
    // 登录
    login(token, username, userId) {
      this.token = token
      this.username = username
      this.userId = userId
      this.isLoggedIn = true
      
      localStorage.setItem('token', token)
      localStorage.setItem('username', username)
      localStorage.setItem('userId', userId)
    },
    
    // 登出
    logout() {
      this.clearUserInfo()
      localStorage.removeItem('token')
      localStorage.removeItem('username')
      localStorage.removeItem('userId')
    }
  }
})
