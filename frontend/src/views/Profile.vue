<template>
  <div class="profile-container">
    <div class="profile-card">
      <el-tabs v-model="activeTab" class="profile-tabs">
        <!-- 个人信息 -->
        <el-tab-pane name="info" label="个人信息">
          <div class="info-section">
            <div class="avatar-upload">
              <el-avatar :size="100" :src="userInfo.avatar">
                {{ userInfo.nickname?.charAt(0) || userInfo.username?.charAt(0) }}
              </el-avatar>
              <el-upload
                class="upload-trigger"
                action="/file/upload/image"
                :headers="uploadHeaders"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
              >
                <el-button type="text" size="small">更换头像</el-button>
              </el-upload>
            </div>
            
            <el-form 
              ref="infoFormRef" 
              :model="infoForm" 
              :rules="infoRules"
              label-width="100px"
              class="info-form"
            >
              <el-form-item label="用户名" prop="username">
                <el-input v-model="infoForm.username" disabled />
              </el-form-item>
              
              <el-form-item label="昵称" prop="nickname">
                <el-input v-model="infoForm.nickname" placeholder="请输入昵称" />
              </el-form-item>
              
              <el-form-item label="邮箱" prop="email">
                <el-input v-model="infoForm.email" placeholder="请输入邮箱" />
              </el-form-item>
              
              <el-form-item label="手机号" prop="phone">
                <el-input v-model="infoForm.phone" placeholder="请输入手机号" />
              </el-form-item>
              
              <el-form-item label="性别" prop="gender">
                <el-radio-group v-model="infoForm.gender">
                  <el-radio :label="0">未知</el-radio>
                  <el-radio :label="1">男</el-radio>
                  <el-radio :label="2">女</el-radio>
                </el-radio-group>
              </el-form-item>
              
              <el-form-item label="个性签名" prop="signature">
                <el-input
                  v-model="infoForm.signature"
                  type="textarea"
                  :rows="3"
                  placeholder="介绍一下自己..."
                  maxlength="200"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="所在地" prop="location">
                <el-input v-model="infoForm.location" placeholder="请输入所在地" />
              </el-form-item>
              
              <el-form-item>
                <el-button type="primary" @click="updateInfo" :loading="loading">
                  保存修改
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 积分记录 -->
        <el-tab-pane name="points" label="积分记录">
          <div class="points-section">
            <div class="points-summary">
              <div class="current-points">
                <span class="label">当前积分</span>
                <span class="value">{{ userInfo.points || 0 }}</span>
              </div>
            </div>
            
            <el-table :data="pointsRecords" v-loading="pointsLoading" style="width: 100%">
              <el-table-column prop="description" label="说明" min-width="200" />
              <el-table-column prop="points" label="积分" width="120">
                <template #default="{ row }">
                  <span :class="row.points > 0 ? 'points-add' : 'points-deduct'">
                    {{ row.points > 0 ? '+' : '' }}{{ row.points }}
                  </span>
                </template>
              </el-table-column>
              <el-table-column prop="balance" label="余额" width="100" />
              <el-table-column prop="createTime" label="时间" width="180" />
            </el-table>
            
            <div class="pagination">
              <el-pagination
                v-model:current-page="pointsPage"
                v-model:page-size="pointsSize"
                :total="pointsTotal"
                @current-change="loadPointsRecords"
              />
            </div>
          </div>
        </el-tab-pane>

        <!-- 我的作品 -->
        <el-tab-pane name="works" label="我的作品">
          <div class="works-section">
            <div class="works-grid">
              <div v-for="work in myWorks" :key="work.id" class="work-card">
                <el-image :src="work.coverImage" fit="cover" class="work-cover" />
                <div class="work-content">
                  <div class="work-title">{{ work.title }}</div>
                  <div class="work-stats">
                    <span><el-icon><View /></el-icon> {{ work.viewCount }}</span>
                    <span><el-icon><Star /></el-icon> {{ work.likeCount }}</span>
                    <span><el-icon><ChatDotRound /></el-icon> {{ work.commentCount }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="myWorks.length === 0" class="empty-state">
              暂无作品，去发布一个吧！
            </div>
          </div>
        </el-tab-pane>

        <!-- 我的课程 -->
        <el-tab-pane name="courses" label="我的课程">
          <div class="courses-section">
            <div v-for="course in myCourses" :key="course.id" class="course-item">
              <el-image :src="course.coverImage" fit="cover" class="course-cover" />
              <div class="course-info">
                <div class="course-title">{{ course.title }}</div>
                <div class="course-progress">
                  <el-progress :percentage="course.progress" :stroke-width="8" />
                </div>
                <div class="course-actions">
                  <el-button type="primary" size="small" @click="continueCourse(course)">
                    继续学习
                  </el-button>
                </div>
              </div>
            </div>
            <div v-if="myCourses.length === 0" class="empty-state">
              暂无已购课程
            </div>
          </div>
        </el-tab-pane>

        <!-- 我的订单 -->
        <el-tab-pane name="orders" label="我的订单">
          <div class="orders-section">
            <el-table :data="myOrders" v-loading="ordersLoading" style="width: 100%">
              <el-table-column prop="orderNo" label="订单号" width="180" />
              <el-table-column prop="itemName" label="商品名称" min-width="200" />
              <el-table-column prop="amount" label="金额" width="100">
                <template #default="{ row }">
                  ¥{{ row.amount }}
                </template>
              </el-table-column>
              <el-table-column prop="status" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="getOrderStatusType(row.status)">
                    {{ getOrderStatusText(row.status) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="createTime" label="创建时间" width="180" />
            </el-table>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { View, Star, ChatDotRound } from '@element-plus/icons-vue'
import axios from 'axios'

const activeTab = ref('info')
const loading = ref(false)
const infoFormRef = ref()

// 用户信息
const userInfo = ref({
  username: '',
  nickname: '',
  email: '',
  phone: '',
  gender: 0,
  signature: '',
  location: '',
  points: 0,
  avatar: ''
})

const infoForm = ref({})
const infoRules = {
  nickname: [{ max: 50, message: '昵称长度不能超过50个字符', trigger: 'blur' }],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
}

// 积分记录
const pointsRecords = ref([])
const pointsLoading = ref(false)
const pointsPage = ref(1)
const pointsSize = ref(10)
const pointsTotal = ref(0)

// 我的作品
const myWorks = ref([])

// 我的课程
const myCourses = ref([])

// 我的订单
const myOrders = ref([])
const ordersLoading = ref(false)

// 上传头像的headers
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return token ? { Authorization: `Bearer ${token}` } : {}
})

// 加载用户信息
const loadUserInfo = async () => {
  try {
    const response = await axios.get('/user/info')
    const { code, data } = response.data
    if (code === 200) {
      userInfo.value = data
      infoForm.value = { ...data }
    }
  } catch (error) {
    ElMessage.error('加载用户信息失败')
  }
}

// 更新用户信息
const updateInfo = async () => {
  if (!infoFormRef.value) return
  
  await infoFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const response = await axios.put('/user/info', infoForm.value)
        const { code, message } = response.data
        if (code === 200) {
          ElMessage.success(message || '更新成功')
          await loadUserInfo()
        } else {
          ElMessage.error(message || '更新失败')
        }
      } catch (error) {
        ElMessage.error('更新失败，请稍后重试')
      } finally {
        loading.value = false
      }
    }
  })
}

// 头像上传成功
const handleAvatarSuccess = (response) => {
  if (response.code === 200) {
    infoForm.value.avatar = response.data.url
    updateInfo()
  } else {
    ElMessage.error(response.message || '头像上传失败')
  }
}

// 头像上传前的校验
const beforeAvatarUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('头像图片大小不能超过 2MB!')
    return false
  }
  return true
}

// 加载积分记录
const loadPointsRecords = async () => {
  pointsLoading.value = true
  try {
    // 模拟数据
    pointsRecords.value = [
      { description: '注册用户', points: 10, balance: 10, createTime: '2024-01-01 10:00:00' },
      { description: '发布作品', points: 5, balance: 15, createTime: '2024-01-02 14:30:00' },
      { description: '每日签到', points: 5, balance: 20, createTime: '2024-01-03 09:00:00' }
    ]
    pointsTotal.value = 3
  } catch (error) {
    ElMessage.error('加载积分记录失败')
  } finally {
    pointsLoading.value = false
  }
}

// 加载我的作品（从当前登录用户获取 userId）
const loadMyWorks = async () => {
  try {
    const userId = localStorage.getItem('userId')
    if (!userId) {
      ElMessage.error('请先登录后再查看作品')
      myWorks.value = []
      return
    }

    const response = await axios.get(`/work/user/${userId}`, {
      params: { page: 1, size: 10 }
    })
    const { code, data } = response.data
    
    if (code === 200) {
      myWorks.value = data.list || []
    } else {
      myWorks.value = []
    }
  } catch (error) {
    ElMessage.error('加载作品失败')
    myWorks.value = []
  }
}

// 加载我的课程
const loadMyCourses = async () => {
  try {
    // 调用后端API获取我的课程
    const response = await axios.get('/course/list?page=1&size=10')
    const { code, data } = response.data
    
    if (code === 200) {
      // 模拟学习进度数据
      myCourses.value = (data.list || []).map(course => ({
        ...course,
        progress: Math.floor(Math.random() * 100) // 随机生成学习进度
      }))
    }
  } catch (error) {
    ElMessage.error('加载课程失败')
    // 如果API调用失败，使用空数组
    myCourses.value = []
  }
}

// 加载我的订单
const loadMyOrders = async () => {
  ordersLoading.value = true
  try {
    // 模拟数据
    myOrders.value = [
      {
        orderNo: '20240101123456',
        itemName: '人像摄影技巧课程',
        amount: 199,
        status: 1,
        createTime: '2024-01-01 12:34:56'
      },
      {
        orderNo: '20240102234567',
        itemName: '摄影技巧手册',
        amount: 800,
        status: 2,
        createTime: '2024-01-02 23:45:67'
      }
    ]
  } catch (error) {
    ElMessage.error('加载订单失败')
  } finally {
    ordersLoading.value = false
  }
}

// 继续学习
const continueCourse = (course) => {
  ElMessage.info(`继续学习: ${course.title}`)
}

// 获取订单状态类型
const getOrderStatusType = (status) => {
  const map = {
    0: 'info',    // 待支付
    1: 'success', // 已支付
    2: 'warning', // 已取消
    3: 'danger'   // 已退款
  }
  return map[status] || 'info'
}

// 获取订单状态文本
const getOrderStatusText = (status) => {
  const map = {
    0: '待支付',
    1: '已支付',
    2: '已取消',
    3: '已退款'
  }
  return map[status] || '未知'
}

// 监听标签页变化
onMounted(() => {
  loadUserInfo()
})

// 监听标签页切换
const handleTabChange = (tab) => {
  if (tab === 'points') {
    loadPointsRecords()
  } else if (tab === 'works') {
    loadMyWorks()
  } else if (tab === 'courses') {
    loadMyCourses()
  } else if (tab === 'orders') {
    loadMyOrders()
  }
}

// 监听activeTab变化
watch(activeTab, (newVal) => {
  handleTabChange(newVal)
})
</script>

<script>
import { watch } from 'vue'
</script>

<style scoped>
.profile-container {
  max-width: 1200px;
  margin: 0 auto;
}

.profile-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.profile-tabs {
  min-height: 500px;
}

/* 个人信息样式 */
.info-section {
  display: flex;
  gap: 40px;
  padding: 20px;
}

.avatar-upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.upload-trigger {
  text-align: center;
}

.info-form {
  flex: 1;
  max-width: 500px;
}

/* 积分记录样式 */
.points-section {
  padding: 20px;
}

.points-summary {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.current-points {
  text-align: center;
  padding: 20px 40px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 8px;
}

.current-points .label {
  display: block;
  font-size: 14px;
  opacity: 0.9;
  margin-bottom: 5px;
}

.current-points .value {
  display: block;
  font-size: 32px;
  font-weight: bold;
}

.points-add {
  color: #67c23a;
  font-weight: bold;
}

.points-deduct {
  color: #f56c6c;
  font-weight: bold;
}

.pagination {
  margin-top: 20px;
  text-align: center;
}

/* 我的作品样式 */
.works-section {
  padding: 20px;
}

.works-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.work-card {
  background: white;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
  cursor: pointer;
}

.work-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.work-cover {
  width: 100%;
  height: 180px;
}

.work-content {
  padding: 12px;
}

.work-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.work-stats {
  display: flex;
  gap: 15px;
  font-size: 12px;
  color: #909399;
}

.work-stats span {
  display: flex;
  align-items: center;
  gap: 3px;
}

/* 我的课程样式 */
.courses-section {
  padding: 20px;
}

.course-item {
  display: flex;
  gap: 15px;
  padding: 15px;
  background: white;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  margin-bottom: 15px;
  transition: all 0.3s;
}

.course-item:hover {
  border-color: #409eff;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.2);
}

.course-cover {
  width: 120px;
  height: 80px;
  border-radius: 4px;
  flex-shrink: 0;
}

.course-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.course-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.course-progress {
  flex: 1;
}

.course-actions {
  text-align: right;
}

/* 我的订单样式 */
.orders-section {
  padding: 20px;
}

/* 空状态 */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #909399;
  font-size: 14px;
}
</style>
