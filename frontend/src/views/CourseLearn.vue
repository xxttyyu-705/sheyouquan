<template>
  <div class="course-learn-container">
    <div class="learn-header">
      <div class="header-left">
        <el-button link @click="$router.push('/courses')">
          <el-icon><ArrowLeft /></el-icon> 返回课程列表
        </el-button>
        <span class="divider">|</span>
        <h2 class="course-title">{{ course.title }}</h2>
      </div>
      <div class="header-right">
        <div class="progress-info">
          <span>学习进度：{{ progressPercentage }}%</span>
          <el-progress :percentage="progressPercentage" :width="100" />
        </div>
      </div>
    </div>

    <div class="learn-content" v-loading="loading">
      <!-- 左侧内容区：视频 + 详情/评论 -->
      <div class="main-section">
        <!-- 视频播放区 -->
        <div class="video-container">
          <div class="video-player" v-if="currentChapter">
            <video 
              v-if="currentChapter.videoUrl"
              ref="videoRef"
              :src="currentChapter.videoUrl" 
              controls 
              autoplay
              class="video-element"
              @ended="handleVideoEnded"
            >
              您的浏览器不支持 HTML5 视频。
            </video>
            <div v-else class="no-video">
              <el-icon :size="60"><VideoPlay /></el-icon>
              <p>该章节暂无视频资源</p>
              <el-button type="primary" @click="handleVideoEnded">标记为已学完</el-button>
            </div>
          </div>
          <div class="video-placeholder" v-else>
            <p>请选择右侧章节开始学习</p>
          </div>
        </div>

        <!-- 课程信息选项卡 -->
        <div class="course-tabs">
          <el-tabs v-model="activeTab">
            <el-tab-pane label="课程介绍" name="intro">
              <div class="tab-content intro-tab">
                <h3>课程简介</h3>
                <p class="description">{{ course.description || '暂无简介' }}</p>
                
                <div class="teacher-info" v-if="course.teacherName">
                  <h3>讲师信息</h3>
                  <div class="teacher-card">
                    <el-avatar :size="50">{{ course.teacherName.charAt(0) }}</el-avatar>
                    <div class="teacher-details">
                      <span class="name">{{ course.teacherName }}</span>
                      <span class="role">主讲教师</span>
                    </div>
                  </div>
                </div>
                
                <div class="current-chapter-info" v-if="currentChapter">
                  <h3>当前章节</h3>
                  <p>{{ currentChapter.title }}</p>
                  <p class="duration">时长：{{ formatDuration(currentChapter.duration) }}</p>
                </div>
              </div>
            </el-tab-pane>
            
            <el-tab-pane label="课程讨论" name="discussion">
              <div class="tab-content discussion-tab">
                <!-- 发表评论 -->
                <div class="comment-input-area">
                  <el-input
                    v-model="newComment"
                    type="textarea"
                    :rows="3"
                    placeholder="发表你的看法，与同学交流..."
                    maxlength="500"
                    show-word-limit
                  />
                  <div class="comment-actions">
                    <el-button type="primary" size="small" @click="submitComment" :loading="submitting">发表评论</el-button>
                  </div>
                </div>
                
                <!-- 评论列表 -->
                <div class="comments-list" v-loading="commentsLoading">
                  <div v-if="comments.length === 0" class="empty-comments">
                    <el-empty description="暂无评论，快来抢沙发吧" :image-size="80" />
                  </div>
                  <div v-else class="comment-item" v-for="item in comments" :key="item.id">
                    <el-avatar :size="40" :src="item.avatar">{{ item.username?.charAt(0) }}</el-avatar>
                    <div class="comment-content-wrapper">
                      <div class="comment-header">
                        <span class="username">{{ item.username }}</span>
                        <span class="time">{{ formatTime(item.createTime) }}</span>
                      </div>
                      <div class="comment-text">{{ item.content }}</div>
                    </div>
                  </div>
                </div>
              </div>
            </el-tab-pane>
          </el-tabs>
        </div>
      </div>

      <!-- 右侧章节列表 -->
      <div class="sidebar-section">
        <div class="chapter-header">
          <h3>课程目录</h3>
          <span class="chapter-count">共 {{ chapters.length }} 节</span>
        </div>
        <div class="chapter-list">
          <div 
            v-for="(chapter, index) in chapters" 
            :key="chapter.id"
            class="chapter-item"
            :class="{ 
              'active': currentChapter?.id === chapter.id,
              'completed': completedChapterIds.includes(chapter.id)
            }"
            @click="selectChapter(chapter)"
          >
            <div class="chapter-icon">
              <el-icon v-if="currentChapter?.id === chapter.id" class="playing-icon"><VideoPlay /></el-icon>
              <el-icon v-else-if="completedChapterIds.includes(chapter.id)" class="completed-icon"><CircleCheckFilled /></el-icon>
              <el-icon v-else class="normal-icon"><CircleCheck /></el-icon>
            </div>
            <div class="chapter-info-right">
              <span class="chapter-title">
                <span class="index">{{ index + 1 }}.</span>
                {{ chapter.title }}
              </span>
              <span class="chapter-meta">
                {{ formatDuration(chapter.duration) }}
                <el-tag size="small" type="success" v-if="completedChapterIds.includes(chapter.id)" effect="plain">已学完</el-tag>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft, VideoPlay, CircleCheck, CircleCheckFilled } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import axios from '@/utils/request'
import dayjs from 'dayjs'

const route = useRoute()
const router = useRouter()
const courseId = route.params.id

const loading = ref(false)
const course = ref({})
const chapters = ref([])
const completedChapterIds = ref([])
const currentChapter = ref(null)
const progressPercentage = ref(0)
const videoRef = ref(null)

// 评论相关
const activeTab = ref('intro')
const comments = ref([])
const newComment = ref('')
const commentsLoading = ref(false)
const submitting = ref(false)

// 加载数据
const loadData = async () => {
  loading.value = true
  try {
    // 1. 获取课程详情
    const courseRes = await axios.get(`/course/detail/${courseId}`)
    if (courseRes.data.code === 200) {
      course.value = courseRes.data.data
    }

    // 2. 获取章节列表
    const chaptersRes = await axios.get(`/course/${courseId}/chapters`)
    if (chaptersRes.data.code === 200) {
      chapters.value = chaptersRes.data.data || []
    }

    // 3. 获取学习进度
    await loadProgress()
    
    // 默认选中第一个未完成的章节，或者第一个章节
    if (chapters.value.length > 0) {
      const firstUncompleted = chapters.value.find(c => !completedChapterIds.value.includes(c.id))
      currentChapter.value = firstUncompleted || chapters.value[0]
    }
    
    // 4. 加载评论
    loadComments()
  } catch (error) {
    console.error('加载失败', error)
    ElMessage.error('加载课程数据失败')
  } finally {
    loading.value = false
  }
}

// 加载进度
const loadProgress = async () => {
  try {
    const progressRes = await axios.get(`/course/${courseId}/progress`)
    if (progressRes.data.code === 200) {
      const data = progressRes.data.data
      completedChapterIds.value = data.completedChapterIds || []
      progressPercentage.value = data.percentage || 0
    }
  } catch (error) {
    console.error('加载进度失败', error)
  }
}

// 加载评论
const loadComments = async () => {
  commentsLoading.value = true
  try {
    const res = await axios.get(`/course/${courseId}/comments`)
    if (res.data.code === 200) {
      comments.value = res.data.data || []
    }
  } catch (error) {
    console.error('加载评论失败', error)
  } finally {
    commentsLoading.value = false
  }
}

// 提交评论
const submitComment = async () => {
  if (!newComment.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }
  
  submitting.value = true
  try {
    const res = await axios.post(`/course/${courseId}/comments`, {
      content: newComment.value
    })
    
    if (res.data.code === 200) {
      ElMessage.success('评论成功')
      newComment.value = ''
      loadComments() // 重新加载评论
    } else {
      ElMessage.error(res.data.message || '评论失败')
    }
  } catch (error) {
    ElMessage.error('评论失败')
  } finally {
    submitting.value = false
  }
}

// 选择章节
const selectChapter = (chapter) => {
  currentChapter.value = chapter
}

// 视频结束或点击完成
const handleVideoEnded = async () => {
  if (!currentChapter.value) return
  
  // 如果已经完成，不再请求
  if (completedChapterIds.value.includes(currentChapter.value.id)) return

  try {
    const res = await axios.post(`/course/${courseId}/chapter/${currentChapter.value.id}/complete`)
    if (res.data.code === 200) {
      ElMessage.success('恭喜完成本节学习！')
      completedChapterIds.value.push(currentChapter.value.id)
      await loadProgress() // 重新计算总进度
      
      // 自动播放下一节
      const currentIndex = chapters.value.findIndex(c => c.id === currentChapter.value.id)
      if (currentIndex < chapters.value.length - 1) {
        setTimeout(() => {
          currentChapter.value = chapters.value[currentIndex + 1]
        }, 1500)
      }
    }
  } catch (error) {
    ElMessage.error('更新进度失败')
  }
}

// 格式化时长
const formatDuration = (seconds) => {
  if (!seconds) return '00:00'
  const min = Math.floor(seconds / 60)
  const sec = seconds % 60
  return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`
}

// 格式化时间
const formatTime = (time) => {
  return dayjs(time).format('YYYY-MM-DD HH:mm')
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.course-learn-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f0f2f5;
}

.learn-header {
  height: 60px;
  background: #2b2e3e; /* Dark header like MOOCs */
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  z-index: 100;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 15px;
}

.header-left .el-button {
  color: #fff;
  font-size: 14px;
}

.header-left .el-button:hover {
  color: #409EFF;
}

.divider {
  color: #5c5e6b;
}

.course-title {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
}

.progress-info {
  display: flex;
  align-items: center;
  gap: 15px;
  font-size: 14px;
  color: #ccc;
}

.learn-content {
  flex: 1;
  display: flex;
  overflow: hidden;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
}

/* Main Section (Left) */
.main-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  background: white;
  margin-right: 1px; /* Separator */
}

.video-container {
  background: #000;
  width: 100%;
  aspect-ratio: 16/9;
  max-height: 60vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.video-player {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.video-element {
  width: 100%;
  height: 100%;
  max-height: 100%;
}

.no-video {
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.course-tabs {
  padding: 20px;
  background: white;
  min-height: 300px;
}

.tab-content {
  padding: 10px 0;
}

.description {
  color: #606266;
  line-height: 1.6;
  margin-bottom: 30px;
}

.teacher-card {
  display: flex;
  align-items: center;
  gap: 15px;
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  width: fit-content;
}

.teacher-details {
  display: flex;
  flex-direction: column;
}

.teacher-details .name {
  font-weight: bold;
  font-size: 16px;
}

.teacher-details .role {
  font-size: 12px;
  color: #909399;
}

/* Discussion Tab */
.comment-input-area {
  margin-bottom: 30px;
}

.comment-actions {
  margin-top: 10px;
  text-align: right;
}

.comment-item {
  display: flex;
  gap: 15px;
  padding: 20px 0;
  border-bottom: 1px solid #ebeef5;
}

.comment-content-wrapper {
  flex: 1;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.comment-header .username {
  font-weight: bold;
  color: #303133;
}

.comment-header .time {
  font-size: 12px;
  color: #909399;
}

.comment-text {
  color: #606266;
  line-height: 1.5;
}

/* Sidebar Section (Right) */
.sidebar-section {
  width: 320px;
  background: #f7f9fc;
  border-left: 1px solid #e0e0e0;
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
}

.chapter-header {
  padding: 15px 20px;
  border-bottom: 1px solid #e0e0e0;
  background: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.chapter-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
}

.chapter-count {
  font-size: 12px;
  color: #909399;
}

.chapter-list {
  flex: 1;
  overflow-y: auto;
}

.chapter-item {
  padding: 15px 20px;
  display: flex;
  gap: 12px;
  cursor: pointer;
  transition: all 0.2s;
  border-bottom: 1px solid #f0f0f0;
}

.chapter-item:hover {
  background: #e6f7ff;
}

.chapter-item.active {
  background: #e6f7ff;
  border-left: 3px solid #1890ff;
}

.chapter-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
}

.playing-icon {
  color: #1890ff;
  font-size: 18px;
  animation: pulse 2s infinite;
}

.completed-icon {
  color: #52c41a;
  font-size: 18px;
}

.normal-icon {
  color: #d9d9d9;
  font-size: 18px;
}

.chapter-info-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.chapter-title {
  font-size: 14px;
  color: #333;
  line-height: 1.4;
}

.chapter-title .index {
  margin-right: 5px;
  color: #909399;
}

.chapter-item.active .chapter-title {
  color: #1890ff;
  font-weight: 500;
}

.chapter-meta {
  font-size: 12px;
  color: #909399;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

@keyframes pulse {
  0% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
  100% { transform: scale(1); opacity: 1; }
}
</style>
