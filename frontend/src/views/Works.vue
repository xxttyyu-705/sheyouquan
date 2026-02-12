<template>
  <div class="works-container">
    <div class="page-header">
      <h2>摄影作品</h2>
      <el-button type="primary" @click="showPublishDialog = true">
        <el-icon><Plus /></el-icon>发布作品
      </el-button>
    </div>

    <!-- 筛选区域 -->
    <div class="filter-section">
      <el-input
        v-model="filters.keyword"
        placeholder="搜索作品标题、描述"
        style="width: 300px"
        @input="handleSearch"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
      
      <el-select v-model="filters.category" placeholder="选择分类" clearable @change="loadWorks" style="margin-left: 10px;">
        <el-option label="人像" value="portrait" />
        <el-option label="风景" value="landscape" />
        <el-option label="街拍" value="street" />
        <el-option label="纪实" value="documentary" />
        <el-option label="其他" value="other" />
      </el-select>
    </div>

    <!-- 作品列表 -->
    <div class="works-grid" v-loading="loading">
      <div v-for="work in works" :key="work.id" class="work-card" @click="viewDetail(work)">
        <el-image :src="work.coverImage" fit="cover" class="work-image" />
        <div class="work-overlay">
          <div class="work-info">
            <div class="work-title">{{ work.title }}</div>
            <div class="work-author">{{ work.authorNickname }}</div>
            <div class="work-stats">
              <span><el-icon><View /></el-icon> {{ work.viewCount }}</span>
              <span><el-icon><Star /></el-icon> {{ work.likeCount }}</span>
              <span><el-icon><ChatDotRound /></el-icon> {{ work.commentCount }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="works.length === 0 && !loading" class="empty-state">
      <el-empty description="暂无作品，快来发布你的摄影作品吧！" />
    </div>

    <!-- 分页 -->
    <div class="pagination" v-if="works.length > 0">
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        @current-change="loadWorks"
      />
    </div>

    <!-- 发布作品对话框 -->
    <el-dialog
      v-model="showPublishDialog"
      title="发布作品"
      width="600px"
      @close="resetPublishForm"
    >
      <el-form
        ref="publishFormRef"
        :model="publishForm"
        :rules="publishRules"
        label-width="100px"
      >
        <el-form-item label="作品标题" prop="title">
          <el-input v-model="publishForm.title" placeholder="请输入作品标题" />
        </el-form-item>
        
        <el-form-item label="作品描述" prop="description">
          <el-input
            v-model="publishForm.description"
            type="textarea"
            :rows="3"
            placeholder="描述你的作品..."
          />
        </el-form-item>

        <el-form-item label="作品分类" prop="categoryId">
          <el-select v-model="publishForm.categoryId" placeholder="选择分类" style="width: 100%">
            <el-option label="人像" :value="1" />
            <el-option label="风景" :value="2" />
            <el-option label="街拍" :value="3" />
            <el-option label="纪实" :value="4" />
            <el-option label="其他" :value="5" />
          </el-select>
        </el-form-item>

        <el-form-item label="标签" prop="tags">
          <el-input v-model="publishForm.tags" placeholder="多个标签用逗号分隔" />
        </el-form-item>

        <el-form-item label="拍摄器材" prop="equipment">
          <el-input v-model="publishForm.equipment" placeholder="如：Canon EOS R5" />
        </el-form-item>

        <el-form-item label="拍摄参数" prop="settings">
          <el-input v-model="publishForm.settings" placeholder="如：f/2.8, 1/200s, ISO 400" />
        </el-form-item>

        <el-form-item label="拍摄地点" prop="location">
          <el-input v-model="publishForm.location" placeholder="请输入拍摄地点" />
        </el-form-item>

        <el-form-item label="拍摄时间" prop="shootTime">
          <el-date-picker
            v-model="publishForm.shootTime"
            type="datetime"
            placeholder="选择拍摄时间"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="封面图" prop="coverImage">
          <el-upload
            class="upload-cover"
            action="/file/upload/image"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleCoverSuccess"
            :before-upload="beforeImageUpload"
          >
            <img v-if="publishForm.coverImage" :src="publishForm.coverImage" class="upload-preview" />
            <el-button v-else type="primary" plain>点击上传封面</el-button>
          </el-upload>
        </el-form-item>

        <el-form-item label="作品图片" prop="images">
          <el-upload
            action="/file/upload/image"
            :headers="uploadHeaders"
            list-type="picture-card"
            :on-success="handleImagesSuccess"
            :on-remove="handleImagesRemove"
            :on-preview="handlePreview"
            :before-upload="beforeImageUpload"
            :file-list="imageList"
          >
            <el-icon><Plus /></el-icon>
          </el-upload>
        </el-form-item>

        <el-form-item label="是否公开" prop="isPublic">
          <el-radio-group v-model="publishForm.isPublic">
            <el-radio :label="1">公开</el-radio>
            <el-radio :label="0">私密</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showPublishDialog = false">取消</el-button>
          <el-button type="primary" @click="handlePublish" :loading="publishing">
            发布
          </el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 作品详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      :title="selectedWork?.title"
      width="800px"
      destroy-on-close
    >
      <div v-if="selectedWork" class="work-detail">
        <div class="detail-images">
          <el-carousel height="400px" v-if="selectedWork.images">
            <el-carousel-item v-for="img in JSON.parse(selectedWork.images)" :key="img">
              <el-image :src="img" fit="contain" style="width: 100%; height: 100%" />
            </el-carousel-item>
          </el-carousel>
          <el-image v-else :src="selectedWork.coverImage" fit="contain" style="width: 100%; height: 400px" />
        </div>
        
        <div class="detail-info">
          <div class="detail-header">
            <div class="author-info">
              <el-avatar :size="40" :src="selectedWork.authorAvatar">
                {{ selectedWork.authorNickname?.charAt(0) }}
              </el-avatar>
              <div>
                <div class="author-name">{{ selectedWork.authorNickname }}</div>
                <div class="detail-time">{{ selectedWork.createTime }}</div>
              </div>
            </div>
            <div class="detail-actions">
              <el-button type="primary" :icon="Star" @click="toggleLike(selectedWork)">
                {{ selectedWork.likeCount }}
              </el-button>
              <el-button type="warning" :icon="Star" @click="toggleCollect(selectedWork)">
                {{ selectedWork.collectCount }}
              </el-button>
            </div>
          </div>

          <div class="detail-content">
            <p class="description">{{ selectedWork.description }}</p>
            
            <div class="meta-info">
              <div v-if="selectedWork.equipment">
                <strong>器材：</strong>{{ selectedWork.equipment }}
              </div>
              <div v-if="selectedWork.settings">
                <strong>参数：</strong>{{ selectedWork.settings }}
              </div>
              <div v-if="selectedWork.location">
                <strong>地点：</strong>{{ selectedWork.location }}
              </div>
              <div v-if="selectedWork.shootTime">
                <strong>时间：</strong>{{ selectedWork.shootTime }}
              </div>
            </div>

            <div v-if="selectedWork.tags" class="tags">
              <el-tag v-for="tag in JSON.parse(selectedWork.tags)" :key="tag" size="small" style="margin-right: 5px">
                {{ tag }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 图片查看器 -->
    <div v-if="showImageViewer" class="image-viewer" @click="showImageViewer = false">
      <img :src="currentImage" alt="查看图片" @click.stop />
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, View, Star, ChatDotRound } from '@element-plus/icons-vue'
import axios from 'axios'
import { debounce } from 'lodash-es'

const router = useRouter()

const loading = ref(false)
const publishing = ref(false)
const showPublishDialog = ref(false)
const showDetailDialog = ref(false)
const works = ref([])
const selectedWork = ref(null)
const publishFormRef = ref()
const imageList = ref([])

// 图片查看器
const showImageViewer = ref(false)
const currentImage = ref('')

// 筛选条件
const filters = reactive({
  keyword: '',
  category: ''
})

// 分页
const pagination = reactive({
  page: 1,
  size: 12,
  total: 0
})

// 发布表单
const publishForm = reactive({
  title: '',
  description: '',
  categoryId: null,
  tags: '',
  equipment: '',
  settings: '',
  location: '',
  shootTime: '',
  coverImage: '',
  images: '',
  isPublic: 1
})

// 表单验证规则
const publishRules = {
  title: [
    { required: true, message: '请输入作品标题', trigger: 'blur' },
    { min: 2, max: 100, message: '标题长度在2-100个字符之间', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入作品描述', trigger: 'blur' }
  ],
  categoryId: [
    { required: true, message: '请选择作品分类', trigger: 'change' }
  ],
  coverImage: [
    { required: true, message: '请上传封面图', trigger: 'change' }
  ]
}

// 上传headers
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return token ? { Authorization: `Bearer ${token}` } : {}
})

// 加载作品列表
const loadWorks = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      size: pagination.size,
      keyword: filters.keyword || undefined,
      categoryId: filters.category || undefined
    }
    
    const response = await axios.get('/work/list', { params })
    const { code, data } = response.data
    
    if (code === 200) {
      works.value = data.list
      pagination.total = data.total
    }
  } catch (error) {
    ElMessage.error('加载作品失败')
  } finally {
    loading.value = false
  }
}

// 搜索防抖
const handleSearch = debounce(() => {
  pagination.page = 1
  loadWorks()
}, 500)

// 封面上传成功
const handleCoverSuccess = (response) => {
  if (response.code === 200) {
    publishForm.coverImage = response.data.url
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error(response.message || '封面上传失败')
  }
}

// 作品图片上传成功
const handleImagesSuccess = (response, file) => {
  if (response.code === 200) {
    // 使用包含 uid 的文件对象，避免删除需点击两次
    imageList.value.push({
      ...file,
      url: response.data.url
    })
    updateImagesString()
  }
}

// 删除作品图片
const handleImagesRemove = (file) => {
  imageList.value = imageList.value.filter(item => item.url !== file.url)
  updateImagesString()
}

// 预览大图
const handlePreview = (file) => {
  if (!file || !file.url) return
  currentImage.value = file.url
  showImageViewer.value = true
}

// 更新图片字符串
function updateImagesString() {
  const urls = imageList.value.map(item => item.url)
  publishForm.images = JSON.stringify(urls)
}

// 图片上传前校验
const beforeImageUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5
  
  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  return true
}

// 发布作品
const handlePublish = async () => {
  if (!publishFormRef.value) return
  
  await publishFormRef.value.validate(async (valid) => {
    if (valid) {
      const token = localStorage.getItem('token')
      if (!token) {
        ElMessage.error('请先登录后再发布作品')
        router.push('/login')
        return
      }

      publishing.value = true
      try {
        // 处理标签
        const tagsArray = publishForm.tags.split(',').map(tag => tag.trim()).filter(tag => tag)
        const formData = {
          ...publishForm,
          tags: JSON.stringify(tagsArray),
          shootTime: publishForm.shootTime ? new Date(publishForm.shootTime).toISOString() : null
        }
        
        const response = await axios.post('/work/publish', formData)
        const { code, message } = response.data
        
        if (code === 200) {
          ElMessage.success(message || '发布成功')
          showPublishDialog.value = false
          resetPublishForm()
          loadWorks()
        } else {
          ElMessage.error(message || '发布失败')
        }
      } catch (error) {
        ElMessage.error('发布失败，请稍后重试')
      } finally {
        publishing.value = false
      }
    }
  })
}

// 重置发布表单
function resetPublishForm() {
  publishForm.title = ''
  publishForm.description = ''
  publishForm.categoryId = null
  publishForm.tags = ''
  publishForm.equipment = ''
  publishForm.settings = ''
  publishForm.location = ''
  publishForm.shootTime = ''
  publishForm.coverImage = ''
  publishForm.images = ''
  publishForm.isPublic = 1
  imageList.value = []
  if (publishFormRef.value) {
    publishFormRef.value.resetFields()
  }
}

// 查看作品详情
const viewDetail = async (work) => {
  try {
    const response = await axios.get(`/work/detail/${work.id}`)
    const { code, data } = response.data
    
    if (code === 200) {
      selectedWork.value = data
      showDetailDialog.value = true
    }
  } catch (error) {
    ElMessage.error('加载作品详情失败')
  }
}

// 点赞/取消点赞
const toggleLike = async (work) => {
  try {
    const response = await axios.post(`/work/like/${work.id}`)
    const { code, message } = response.data
    
    if (code === 200) {
      ElMessage.success(message || '操作成功')
      // 重新加载详情
      if (selectedWork.value) {
        const detailResponse = await axios.get(`/work/detail/${selectedWork.value.id}`)
        if (detailResponse.data.code === 200) {
          selectedWork.value = detailResponse.data.data
        }
      }
      // 更新列表中的数据
      const index = works.value.findIndex(w => w.id === work.id)
      if (index !== -1) {
        works.value[index].likeCount += 1
      }
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 收藏/取消收藏
const toggleCollect = async (work) => {
  try {
    const response = await axios.post(`/work/collect/${work.id}`)
    const { code, message } = response.data
    
    if (code === 200) {
      ElMessage.success(message || '操作成功')
      // 重新加载详情
      if (selectedWork.value) {
        const detailResponse = await axios.get(`/work/detail/${selectedWork.value.id}`)
        if (detailResponse.data.code === 200) {
          selectedWork.value = detailResponse.data.data
        }
      }
      // 更新列表中的数据
      const index = works.value.findIndex(w => w.id === work.id)
      if (index !== -1) {
        works.value[index].collectCount += 1
      }
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  loadWorks()
})
</script>

<style scoped>
.works-container {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

.works-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.work-card {
  position: relative;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  height: 250px;
}

.work-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
}

.work-image {
  width: 100%;
  height: 100%;
  transition: transform 0.3s;
}

.work-card:hover .work-image {
  transform: scale(1.05);
}

.work-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent);
  padding: 15px;
  color: white;
  opacity: 0;
  transition: opacity 0.3s;
}

.work-card:hover .work-overlay {
  opacity: 1;
}

.work-info {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.work-title {
  font-size: 16px;
  font-weight: bold;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.work-author {
  font-size: 12px;
  opacity: 0.9;
}

.work-stats {
  display: flex;
  gap: 15px;
  font-size: 12px;
  margin-top: 5px;
}

.work-stats span {
  display: flex;
  align-items: center;
  gap: 3px;
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

.upload-cover {
  width: 100%;
}

.upload-preview {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 4px;
}

.work-detail {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-images {
  background: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.detail-info {
  padding: 10px 0;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #e4e7ed;
}

.author-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.author-name {
  font-weight: bold;
  color: #333;
}

.detail-time {
  font-size: 12px;
  color: #999;
}

.detail-actions {
  display: flex;
  gap: 10px;
}

.detail-content {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.description {
  line-height: 1.6;
  color: #666;
  margin: 0;
}

.meta-info {
  background: #f5f7fa;
  padding: 15px;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 14px;
}

.meta-info div {
  display: flex;
  gap: 8px;
}

.meta-info strong {
  color: #333;
  min-width: 60px;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

/* 图片查看器 */
.image-viewer {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.9);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 2000;
  cursor: pointer;
}

.image-viewer img {
  max-width: 90%;
  max-height: 90%;
  object-fit: contain;
  border-radius: 8px;
}
</style>
