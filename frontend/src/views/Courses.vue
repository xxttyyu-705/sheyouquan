<template>
  <div class="courses-container">
    <div class="page-header">
      <h2>摄影课程</h2>
    </div>

    <!-- 筛选区域 -->
    <div class="filter-section">
      <el-input
        v-model="filters.keyword"
        placeholder="搜索课程标题、描述"
        style="width: 300px"
        @input="handleSearch"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
      
      <el-select v-model="filters.category" placeholder="选择分类" clearable @change="loadCourses" style="margin-left: 10px;">
        <el-option label="基础入门" value="basic" />
        <el-option label="人像摄影" value="portrait" />
        <el-option label="风景摄影" value="landscape" />
        <el-option label="后期处理" value="post" />
        <el-option label="器材使用" value="equipment" />
      </el-select>

      <el-select v-model="filters.difficulty" placeholder="难度等级" clearable @change="loadCourses" style="margin-left: 10px;">
        <el-option label="入门" :value="1" />
        <el-option label="中级" :value="2" />
        <el-option label="高级" :value="3" />
      </el-select>
    </div>

    <!-- 课程列表 -->
    <div class="courses-grid" v-loading="loading">
      <div v-for="course in courses" :key="course.id" class="course-card">
        <div class="course-cover" @click="viewDetail(course)">
          <el-image :src="course.coverImage" fit="cover" style="width: 100%; height: 100%" />
          <div class="course-overlay">
            <el-icon><VideoPlay /></el-icon>
          </div>
        </div>
        <div class="course-info">
          <div class="course-title" @click="viewDetail(course)">{{ course.title }}</div>
          <div class="course-meta">
            <span class="difficulty" :class="'level-' + course.difficulty">
              {{ getDifficultyText(course.difficulty) }}
            </span>
            <span class="duration">{{ course.duration }}分钟</span>
            <span class="students">{{ course.studentCount }}人学习</span>
          </div>
          <div class="course-footer">
            <span class="teacher">讲师：{{ course.teacherName }}</span>
            <span class="price" :class="{ free: course.isFree === 1 }">
              {{ course.isFree === 1 ? '免费' : '¥' + course.price }}
            </span>
          </div>
          <div class="course-actions">
            <el-button type="primary" size="small" @click="viewDetail(course)">
              查看详情
            </el-button>
            <el-button type="success" size="small" @click="handleLearn(course)">
              {{ course.isFree === 1 ? '开始学习' : '立即购买' }}
            </el-button>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="courses.length === 0 && !loading" class="empty-state">
      <el-empty description="暂无课程，敬请期待！" />
    </div>

    <!-- 分页 -->
    <div class="pagination" v-if="courses.length > 0">
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        @current-change="loadCourses"
      />
    </div>

    <!-- 课程详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      :title="selectedCourse?.title"
      width="800px"
      destroy-on-close
    >
      <div v-if="selectedCourse" class="course-detail">
        <div class="detail-cover">
          <el-image :src="selectedCourse.coverImage" fit="contain" style="width: 100%; height: 300px; border-radius: 8px" />
        </div>

        <div class="detail-info">
          <div class="detail-meta">
            <div class="meta-item">
              <span class="label">难度：</span>
              <span class="value">{{ getDifficultyText(selectedCourse.difficulty) }}</span>
            </div>
            <div class="meta-item">
              <span class="label">时长：</span>
              <span class="value">{{ selectedCourse.duration }}分钟</span>
            </div>
            <div class="meta-item">
              <span class="label">学习人数：</span>
              <span class="value">{{ selectedCourse.studentCount }}人</span>
            </div>
            <div class="meta-item">
              <span class="label">讲师：</span>
              <span class="value">{{ selectedCourse.teacherName }}</span>
            </div>
          </div>

          <div class="detail-description">
            <h4>课程介绍</h4>
            <p>{{ selectedCourse.description }}</p>
          </div>

          <div class="detail-actions">
            <el-button type="primary" size="large" @click="handleLearn(selectedCourse)">
              {{ selectedCourse.isFree === 1 ? '开始学习' : '立即购买 - ¥' + selectedCourse.price }}
            </el-button>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 购买确认对话框 -->
    <el-dialog
      v-model="showPurchaseDialog"
      title="确认购买"
      width="500px"
    >
      <div v-if="selectedCourse" class="purchase-info">
        <div class="purchase-item">
          <span>课程名称：</span>
          <span>{{ selectedCourse.title }}</span>
        </div>
        <div class="purchase-item">
          <span>课程价格：</span>
          <span class="price">¥{{ selectedCourse.price }}</span>
        </div>
        <div class="purchase-item">
          <span>支付方式：</span>
          <el-radio-group v-model="purchaseForm.payType">
            <el-radio :label="1">微信支付</el-radio>
            <el-radio :label="2">支付宝</el-radio>
            <el-radio :label="3">积分支付</el-radio>
          </el-radio-group>
        </div>
        <div class="purchase-item" v-if="purchaseForm.payType === 3">
          <span>使用积分：</span>
          <el-input-number 
            v-model="purchaseForm.usePoints" 
            :min="0" 
            :max="userPoints" 
            :step="10"
            size="small"
          />
          <span class="points-balance">可用：{{ userPoints }}</span>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showPurchaseDialog = false">取消</el-button>
          <el-button type="primary" @click="handlePurchase" :loading="purchasing">
            确认支付
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, VideoPlay } from '@element-plus/icons-vue'
import axios from 'axios'
import { debounce } from 'lodash-es'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const purchasing = ref(false)
const showDetailDialog = ref(false)
const showPurchaseDialog = ref(false)
const courses = ref([])
const selectedCourse = ref(null)
const userPoints = ref(0)

// 筛选条件
const filters = reactive({
  keyword: '',
  category: '',
  difficulty: null
})

// 分页
const pagination = reactive({
  page: 1,
  size: 9,
  total: 0
})

// 购买表单
const purchaseForm = reactive({
  payType: 1,
  usePoints: 0
})

// 加载课程列表
const loadCourses = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      size: pagination.size,
      keyword: filters.keyword || undefined,
      category: filters.category || undefined,
      difficulty: filters.difficulty || undefined
    }
    
    const response = await axios.get('/course/list', { params })
    const { code, data } = response.data
    
    if (code === 200) {
      courses.value = data.list
      pagination.total = data.total
    }
  } catch (error) {
    ElMessage.error('加载课程失败')
  } finally {
    loading.value = false
  }
}

// 搜索防抖
const handleSearch = debounce(() => {
  pagination.page = 1
  loadCourses()
}, 500)

// 获取难度文本
const getDifficultyText = (difficulty) => {
  const map = { 1: '入门', 2: '中级', 3: '高级' }
  return map[difficulty] || '未知'
}

// 查看课程详情
const viewDetail = async (course) => {
  try {
    const response = await axios.get(`/course/detail/${course.id}`)
    const { code, data } = response.data
    
    if (code === 200) {
      selectedCourse.value = data
      showDetailDialog.value = true
    }
  } catch (error) {
    ElMessage.error('加载课程详情失败')
  }
}

// 处理学习/购买
const handleLearn = async (course) => {
  if (course.isFree === 1) {
    // 免费课程，直接开始学习
    try {
      await axios.post(`/course/learn/${course.id}`)
      ElMessage.success('开始学习')
      showDetailDialog.value = false
      // 跳转到学习页面（这里可以扩展为视频播放页面）
      ElMessage.info('即将跳转到学习页面')
    } catch (error) {
      ElMessage.error('操作失败')
    }
  } else {
    // 收费课程，打开购买对话框
    selectedCourse.value = course
    showPurchaseDialog.value = true
    showDetailDialog.value = false
    // 加载用户积分
    await loadUserPoints()
  }
}

// 加载用户积分
const loadUserPoints = async () => {
  try {
    const response = await axios.get('/user/info')
    const { code, data } = response.data
    if (code === 200) {
      userPoints.value = data.points || 0
    }
  } catch (error) {
    console.error('加载用户积分失败:', error)
  }
}

// 处理购买
const handlePurchase = async () => {
  if (!selectedCourse.value) return
  
  // 检查积分是否足够
  if (purchaseForm.payType === 3) {
    const totalCost = selectedCourse.value.price * 100 // 1元 = 100积分
    const pointsNeeded = totalCost - (purchaseForm.usePoints || 0)
    if (pointsNeeded > userPoints.value) {
      ElMessage.error('积分不足')
      return
    }
  }
  
  purchasing.value = true
  try {
    const response = await axios.post('/order/create', null, {
      params: {
        itemId: selectedCourse.value.id,
        itemType: 1, // 课程
        itemName: selectedCourse.value.title,
        itemImage: selectedCourse.value.coverImage,
        price: selectedCourse.value.price,
        payType: purchaseForm.payType,
        usePoints: purchaseForm.usePoints || 0
      }
    })
    
    const { code, message, data } = response.data
    
    if (code === 200) {
      ElMessage.success(message || '订单创建成功')
      
      // 模拟支付
      const payResponse = await axios.post(`/order/pay/${data.id}`)
      if (payResponse.data.code === 200) {
        ElMessage.success('支付成功！')
        showPurchaseDialog.value = false
        // 重置表单
        purchaseForm.payType = 1
        purchaseForm.usePoints = 0
        // 重新加载课程列表
        loadCourses()
      }
    } else {
      ElMessage.error(message || '购买失败')
    }
  } catch (error) {
    ElMessage.error('购买失败，请稍后重试')
  } finally {
    purchasing.value = false
  }
}

onMounted(() => {
  loadCourses()
})
</script>

<style scoped>
.courses-container {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  color: #333;
}

.filter-section {
  background: white;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.courses-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.course-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s;
}

.course-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.course-cover {
  position: relative;
  height: 200px;
  cursor: pointer;
  overflow: hidden;
}

.course-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
  color: white;
  font-size: 48px;
}

.course-cover:hover .course-overlay {
  opacity: 1;
}

.course-info {
  padding: 15px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.course-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  cursor: pointer;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-title:hover {
  color: #409eff;
}

.course-meta {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: #666;
  align-items: center;
}

.difficulty {
  padding: 2px 8px;
  border-radius: 4px;
  font-weight: bold;
}

.difficulty.level-1 {
  background: #e1f3d8;
  color: #67c23a;
}

.difficulty.level-2 {
  background: #faecd8;
  color: #e6a23c;
}

.difficulty.level-3 {
  background: #fde2e2;
  color: #f56c6c;
}

.duration, .students {
  color: #909399;
}

.course-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 8px;
  border-top: 1px solid #e4e7ed;
}

.teacher {
  font-size: 12px;
  color: #666;
}

.price {
  font-size: 18px;
  font-weight: bold;
  color: #f56c6c;
}

.price.free {
  color: #67c23a;
  font-size: 14px;
}

.course-actions {
  display: flex;
  gap: 8px;
  margin-top: 8px;
}

.empty-state {
  background: white;
  padding: 60px 20px;
  border-radius: 8px;
  text-align: center;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.course-detail {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-cover {
  background: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.detail-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.detail-meta {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
  background: #f5f7fa;
  padding: 15px;
  border-radius: 6px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.meta-item .label {
  color: #666;
  font-weight: 500;
}

.meta-item .value {
  color: #333;
  font-weight: bold;
}

.detail-description h4 {
  margin: 0 0 10px 0;
  color: #333;
}

.detail-description p {
  margin: 0;
  line-height: 1.6;
  color: #666;
}

.detail-actions {
  display: flex;
  justify-content: center;
  margin-top: 10px;
}

.purchase-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.purchase-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.purchase-item .price {
  color: #f56c6c;
  font-weight: bold;
  font-size: 18px;
}

.points-balance {
  color: #666;
  font-size: 12px;
  margin-left: 10px;
}
</style>
