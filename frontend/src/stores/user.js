import { defineStore } from 'pinia';

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || null,
    user: JSON.parse(localStorage.getItem('user')) || null,
  }),
  getters: {
    isLoggedIn: (state) => !!state.token && !!state.user,
    isAdmin: (state) => state.user?.role === 'admin',
  },
  actions: {
    login(userData) {
      this.token = userData.token;
      this.user = userData.user;

      localStorage.setItem('token', userData.token);
      localStorage.setItem('user', JSON.stringify(userData.user));
    },

    logout() {
      this.token = null;
      this.user = null;

      localStorage.removeItem('token');
      localStorage.removeItem('user');
    },

    checkLoginStatus() {
      const token = localStorage.getItem('token');
      const userJSON = localStorage.getItem('user');

      if (token && userJSON) {
        try {
          this.token = token;
          this.user = JSON.parse(userJSON);
          return true;
        } catch (e) {
          this.logout();
          return false;
        }
      } else {
        this.logout();
        return false;
      }
    },
  },
});
