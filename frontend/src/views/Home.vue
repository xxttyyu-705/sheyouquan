<template>
  <div class="home-container">
    <!-- 欢迎区域 -->
    <div class="welcome-section">
      <div class="welcome-content">
        <h1>欢迎来到摄友圈</h1>
        <p>发现精彩瞬间，分享摄影艺术，交流创作心得</p>
        <div class="stats">
          <div class="stat-item">
            <div class="stat-number">{{ stats.userCount || 0 }}</div>
            <div class="stat-label">注册用户</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ stats.workCount || 0 }}</div>
            <div class="stat-label">摄影作品</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">{{ stats.courseCount || 0 }}</div>
            <div class="stat-label">精品课程</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 快捷入口 -->
    <div class="quick-access">
      <h3>快速入口</h3>
      <div class="access-grid">
        <div class="access-item" @click="$router.push('/works')">
          <el-icon size="32"><Picture /></el-icon>
          <span>发布作品</span>
        </div>
        <div class="access-item" @click="$router.push('/courses')">
          <el-icon size="32"><VideoPlay /></el-icon>
          <span>学习课程</span>
        </div>
        <div class="access-item" @click="$router.push('/mall')">
          <el-icon size="32"><ShoppingCart /></el-icon>
          <span>积分商城</span>
        </div>
        <div class="access-item" @click="$router.push('/community')">
          <el-icon size="32"><ChatDotRound /></el-icon>
          <span>社区互动</span>
        </div>
      </div>
    </div>

    <!-- 推荐内容 -->
    <div class="recommendations">
      <el-row :gutter="20">
        <el-col :span="12">
          <div class="recommend-section">
            <h3>热门作品</h3>
            <div class="work-list">
              <div v-for="work in hotWorks" :key="work.id" class="work-item">
                <el-image :src="work.coverImage" fit="cover" class="work-image" />
                <div class="work-info">
                  <div class="work-title">{{ work.title }}</div>
                  <div class="work-author">{{ work.author }}</div>
                </div>
              </div>
              <div v-if="hotWorks.length === 0" class="empty-state">
                暂无热门作品
              </div>
            </div>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="recommend-section">
            <h3>推荐课程</h3>
            <div class="course-list">
              <div v-for="course in recommendedCourses" :key="course.id" class="course-item">
                <el-image :src="course.coverImage" fit="cover" class="course-image" />
                <div class="course-info">
                  <div class="course-title">{{ course.title }}</div>
                  <div class="course-meta">
                    <span v-if="course.isFree" class="free-tag">免费</span>
                    <span v-else class="price">¥{{ course.price }}</span>
                  </div>
                </div>
              </div>
              <div v-if="recommendedCourses.length === 0" class="empty-state">
                暂无推荐课程
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Picture, VideoPlay, ShoppingCart, ChatDotRound } from '@element-plus/icons-vue'
import axios from 'axios'

const stats = ref({
  userCount: 0,
  workCount: 0,
  courseCount: 0
})

const hotWorks = ref([])
const recommendedCourses = ref([])

const fetchStats = async () => {
  try {
    // 这里应该调用统计接口，暂时使用模拟数据
    stats.value = {
      userCount: 1234,
      workCount: 5678,
      courseCount: 89
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

const fetchHotWorks = async () => {
  try {
    // 调用后端API获取热门作品
    const response = await axios.get('/work/hot?limit=2')
    const { code, data } = response.data
    
    if (code === 200) {
      hotWorks.value = data.list || []
    }
  } catch (error) {
    console.error('获取热门作品失败:', error)
    // 如果API调用失败，使用空数组
    hotWorks.value = []
  }
}

const fetchRecommendedCourses = async () => {
  try {
    // 调用后端API获取推荐课程
    const response = await axios.get('/course/recommended?limit=2')
    const { code, data } = response.data
    
    if (code === 200) {
      recommendedCourses.value = data.list || []
    }
  } catch (error) {
    console.error('获取推荐课程失败:', error)
    // 如果API调用失败，使用空数组
    recommendedCourses.value = []
  }
}

onMounted(() => {
  fetchStats()
  fetchHotWorks()
  fetchRecommendedCourses()
})
</script>

<style scoped>
.home-container {
  max-width: 1200px;
  margin: 0 auto;
}

.welcome-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  padding: 60px 40px;
  margin-bottom: 30px;
  text-align: center;
}

.welcome-content h1 {
  font-size: 36px;
  margin: 0 0 10px;
}

.welcome-content p {
  font-size: 18px;
  opacity: 0.9;
  margin: 0 0 30px;
}

.stats {
  display: flex;
  justify-content: center;
  gap: 60px;
  margin-top: 30px;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  opacity: 0.8;
}

.quick-access {
  margin-bottom: 30px;
}

.quick-access h3 {
  margin-bottom: 15px;
  color: #333;
}

.access-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 15px;
}

.access-item {
  background: white;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  border: 1px solid #e4e7ed;
}

.access-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  border-color: #409eff;
}

.access-item .el-icon {
  color: #409eff;
  margin-bottom: 8px;
}

.access-item span {
  font-size: 14px;
  color: #606266;
}

.recommendations {
  margin-bottom: 30px;
}

.recommend-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #e4e7ed;
}

.recommend-section h3 {
  margin: 0 0 15px;
  color: #333;
  font-size: 18px;
}

.work-list, .course-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.work-item, .course-item {
  display: flex;
  gap: 12px;
  padding: 10px;
  border-radius: 6px;
  transition: background 0.3s;
  cursor: pointer;
}

.work-item:hover, .course-item:hover {
  background: #f5f7fa;
}

.work-image, .course-image {
  width: 80px;
  height: 60px;
  border-radius: 4px;
  flex-shrink: 0;
}

.work-info, .course-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  overflow: hidden;
}

.work-title, .course-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.work-author {
  font-size: 12px;
  color: #909399;
}

.course-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.free-tag {
  background: #67c23a;
  color: white;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
}

.price {
  color: #f56c6c;
  font-weight: bold;
  font-size: 14px;
}

.empty-state {
  text-align: center;
  color: #909399;
  padding: 20px;
  font-size: 14px;
}
</style>
