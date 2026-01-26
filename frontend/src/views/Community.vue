<template>
  <div class="community">
    <header class="header">
      <h1>摄影社区</h1>
      <button class="create-btn" @click="showCreatePost = true" v-if="userStore.isLoggedIn">
        发布帖子
      </button>
    </header>

    <!-- 帖子列表 -->
    <div class="posts-container">
      <div class="search-section">
        <input 
          v-model="searchKeyword" 
          placeholder="搜索帖子..." 
          @keyup.enter="loadPosts"
        />
        <button @click="loadPosts">搜索</button>
      </div>

      <div class="posts-list" v-loading="loading">
        <div 
          v-for="post in posts" 
          :key="post.id" 
          class="post-card"
          @click="showPostDetail(post)"
        >
          <div class="post-header">
            <div class="user-info">
              <span class="username">{{ post.username }}</span>
              <span class="time">{{ formatDate(post.createTime) }}</span>
            </div>
            <div class="post-stats">
              <span class="stat">👁️ {{ post.views }}</span>
              <span class="stat">👍 {{ post.likes }}</span>
              <span class="stat">💬 {{ post.comments }}</span>
            </div>
          </div>
          <div class="post-content">
            <h3>{{ post.title }}</h3>
            <p>{{ post.content }}</p>
            <div v-if="post.images" class="post-images">
              <img 
                v-for="(img, idx) in JSON.parse(post.images)" 
                :key="idx" 
                :src="img" 
                :alt="'图片' + (idx + 1)"
                @click.stop="viewImage(img)"
              />
            </div>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination" v-if="totalPages > 1">
        <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
          上一页
        </button>
        <span>{{ currentPage }} / {{ totalPages }}</span>
        <button :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">
          下一页
        </button>
      </div>

      <!-- 空状态 -->
      <div v-if="posts.length === 0 && !loading" class="empty-state">
        <p>暂无帖子，快来发布第一帖吧！</p>
      </div>
    </div>

    <!-- 发布帖子弹窗 -->
    <div v-if="showCreatePost" class="modal-overlay" @click="showCreatePost = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>发布新帖子</h2>
          <button class="close-btn" @click="showCreatePost = false">×</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>标题:</label>
            <input 
              v-model="newPost.title" 
              type="text" 
              placeholder="输入帖子标题"
              required
            />
          </div>
          <div class="form-group">
            <label>内容:</label>
            <textarea 
              v-model="newPost.content" 
              placeholder="分享你的摄影心得、作品或问题..."
              rows="6"
              required
            ></textarea>
          </div>
          <div class="form-group">
            <label>图片 (可选，最多3张):</label>
            <div class="image-upload">
              <input 
                type="file" 
                accept="image/*" 
                multiple 
                @change="handleImageUpload"
                ref="fileInput"
              />
              <div class="image-preview" v-if="newPost.images.length > 0">
                <div v-for="(img, idx) in newPost.images" :key="idx" class="preview-item">
                  <img :src="img" :alt="'预览' + (idx + 1)" />
                  <button @click="removeImage(idx)">×</button>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-actions">
            <button class="cancel-btn" @click="showCreatePost = false">取消</button>
            <button 
              class="confirm-btn" 
              :disabled="!canCreatePost || submitting"
              @click="submitPost"
            >
              {{ submitting ? '发布中...' : '发布帖子' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 帖子详情弹窗 -->
    <div v-if="showPostDetailModal" class="modal-overlay" @click="closePostDetail">
      <div class="modal-content post-detail-modal" @click.stop>
        <div class="modal-header">
          <h2>{{ selectedPost?.title }}</h2>
          <button class="close-btn" @click="closePostDetail">×</button>
        </div>
        <div class="modal-body">
          <!-- 帖子内容 -->
          <div class="post-detail-content">
            <div class="post-meta">
              <span class="username">{{ selectedPost?.username }}</span>
              <span class="time">{{ formatDate(selectedPost?.createTime) }}</span>
              <div class="stats">
                <span>👁️ {{ selectedPost?.views }}</span>
                <span 
                  class="like-btn" 
                  :class="{ liked: hasLiked }"
                  @click="likePost"
                >
                  👍 {{ selectedPost?.likes }}
                </span>
                <span>💬 {{ selectedPost?.comments }}</span>
              </div>
            </div>
            <div class="post-text">{{ selectedPost?.content }}</div>
            <div v-if="selectedPost?.images" class="post-images">
              <img 
                v-for="(img, idx) in JSON.parse(selectedPost.images)" 
                :key="idx" 
                :src="img" 
                :alt="'图片' + (idx + 1)"
                @click="viewImage(img)"
              />
            </div>
          </div>

          <!-- 评论区域 -->
          <div class="comments-section">
            <h3>评论 ({{ commentTotal }})</h3>
            
            <!-- 评论输入 -->
            <div class="comment-input" v-if="userStore.isLoggedIn">
              <textarea 
                v-model="newComment.content" 
                placeholder="写下你的评论..."
                rows="3"
              ></textarea>
              <div class="comment-actions">
                <button 
                  class="submit-comment" 
                  :disabled="!newComment.content.trim() || commentSubmitting"
                  @click="submitComment"
                >
                  {{ commentSubmitting ? '提交中...' : '发表评论' }}
                </button>
              </div>
            </div>
            <div v-else class="login-prompt">
              <p>请 <a href="#" @click.prevent="$router.push('/login')">登录</a> 后发表评论</p>
            </div>

            <!-- 评论列表 -->
            <div class="comments-list" v-loading="commentsLoading">
              <div 
                v-for="comment in comments" 
                :key="comment.id" 
                class="comment-item"
              >
                <div class="comment-header">
                  <span class="comment-username">{{ comment.username }}</span>
                  <span class="comment-time">{{ formatDate(comment.createTime) }}</span>
                </div>
                <div class="comment-content">
                  <span v-if="comment.replyToUsername" class="reply-to">
                    @{{ comment.replyToUsername }} 
                  </span>
                  {{ comment.content }}
                </div>
                <div class="comment-actions">
                  <button 
                    v-if="userStore.isLoggedIn"
                    @click="replyComment(comment)"
                    class="reply-btn"
                  >
                    回复
                  </button>
                  <button 
                    v-if="userStore.user?.role === 'admin'"
                    @click="deleteComment(comment.id)"
                    class="delete-btn"
                  >
                    删除
                  </button>
                </div>
              </div>
              <div v-if="comments.length === 0" class="empty-comments">
                暂无评论，快来发表你的看法吧！
              </div>
            </div>

            <!-- 评论分页 -->
            <div class="comment-pagination" v-if="commentTotalPages > 1">
              <button 
                :disabled="currentCommentPage === 1" 
                @click="changeCommentPage(currentCommentPage - 1)"
              >
                上一页
              </button>
              <span>{{ currentCommentPage }} / {{ commentTotalPages }}</span>
              <button 
                :disabled="currentCommentPage === commentTotalPages" 
                @click="changeCommentPage(currentCommentPage + 1)"
              >
                下一页
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 回复弹窗 -->
    <div v-if="showReplyModal" class="modal-overlay" @click="showReplyModal = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>回复 {{ replyToComment?.username }}</h2>
          <button class="close-btn" @click="showReplyModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>回复内容:</label>
            <textarea 
              v-model="replyContent" 
              placeholder="写下你的回复..."
              rows="4"
              required
            ></textarea>
          </div>
          <div class="modal-actions">
            <button class="cancel-btn" @click="showReplyModal = false">取消</button>
            <button 
              class="confirm-btn" 
              :disabled="!replyContent.trim() || replySubmitting"
              @click="submitReply"
            >
              {{ replySubmitting ? '提交中...' : '回复' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 图片查看器 -->
    <div v-if="showImageViewer" class="image-viewer" @click="showImageViewer = false">
      <img :src="currentImage" alt="查看图片" @click.stop />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useUserStore } from '../stores/user'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const userStore = useUserStore()

// 帖子数据
const posts = ref([])
const loading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)
const searchKeyword = ref('')

// 创建帖子相关
const showCreatePost = ref(false)
const newPost = ref({
  title: '',
  content: '',
  images: []
})
const submitting = ref(false)

// 帖子详情相关
const showPostDetailModal = ref(false)
const selectedPost = ref(null)
const hasLiked = ref(false)

// 评论相关
const comments = ref([])
const commentsLoading = ref(false)
const currentCommentPage = ref(1)
const commentTotalPages = ref(1)
const commentTotal = ref(0)
const newComment = ref({ content: '' })
const commentSubmitting = ref(false)

// 回复相关
const showReplyModal = ref(false)
const replyToComment = ref(null)
const replyContent = ref('')
const replySubmitting = ref(false)

// 图片查看器
const showImageViewer = ref(false)
const currentImage = ref('')

// 计算属性
const canCreatePost = computed(() => {
  return newPost.value.title.trim() && newPost.value.content.trim()
})

// 加载帖子列表
const loadPosts = async () => {
  try {
    loading.value = true
    const params = {
      page: currentPage.value,
      size: 10,
      keyword: searchKeyword.value
    }
    
    const response = await axios.get('/post/list', { params })
    if (response.data.code === 200) {
      posts.value = response.data.data.list
      totalPages.value = response.data.data.pages
    }
  } catch (error) {
    ElMessage.error('加载帖子失败')
  } finally {
    loading.value = false
  }
}

// 处理图片上传
const handleImageUpload = (event) => {
  const files = event.target.files
  if (files.length + newPost.value.images.length > 3) {
    ElMessage.warning('最多只能上传3张图片')
    return
  }

  Array.from(files).forEach(file => {
    if (file.size > 5 * 1024 * 1024) {
      ElMessage.warning('单张图片不能超过5MB')
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      newPost.value.images.push(e.target.result)
    }
    reader.readAsDataURL(file)
  })
}

// 移除图片
const removeImage = (index) => {
  newPost.value.images.splice(index, 1)
}

// 提交帖子
const submitPost = async () => {
  if (!canCreatePost.value || submitting.value) return

  try {
    submitting.value = true
    
    const response = await axios.post('/post/create', 
      {
        title: newPost.value.title,
        content: newPost.value.content,
        images: newPost.value.images.length > 0 ? JSON.stringify(newPost.value.images) : null
      }
    )
    
    if (response.data.code === 200) {
      ElMessage.success('帖子发布成功！')
      showCreatePost.value = false
      // 重置表单
      newPost.value = { title: '', content: '', images: [] }
      // 刷新列表
      loadPosts()
    } else {
      ElMessage.error(response.data.message || '发布失败')
    }
  } catch (error) {
    ElMessage.error('发布失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}

// 显示帖子详情
const showPostDetail = async (post) => {
  selectedPost.value = post
  hasLiked.value = false // 重置点赞状态
  showPostDetailModal.value = true
  currentCommentPage.value = 1
  await loadComments()
}

// 关闭帖子详情
const closePostDetail = () => {
  showPostDetailModal.value = false
  selectedPost.value = null
  comments.value = []
  newComment.value = { content: '' }
}

// 点赞帖子
const likePost = async () => {
  if (!selectedPost.value || hasLiked.value) return
  
  try {
    const response = await axios.post(`/post/like/${selectedPost.value.id}`)
    if (response.data.code === 200) {
      hasLiked.value = true
      selectedPost.value.likes += 1
      ElMessage.success('点赞成功')
    }
  } catch (error) {
    ElMessage.error('点赞失败')
  }
}

// 加载评论
const loadComments = async () => {
  if (!selectedPost.value) return
  
  try {
    commentsLoading.value = true
    const params = {
      postId: selectedPost.value.id,
      page: currentCommentPage.value,
      size: 10
    }
    
    const response = await axios.get('/comment/list', { params })
    if (response.data.code === 200) {
      comments.value = response.data.data.list
      commentTotalPages.value = response.data.data.pages
      commentTotal.value = response.data.data.total
    }
  } catch (error) {
    ElMessage.error('加载评论失败')
  } finally {
    commentsLoading.value = false
  }
}

// 提交评论
const submitComment = async () => {
  if (!newComment.value.content.trim() || commentSubmitting.value) return

  try {
    commentSubmitting.value = true
    
    const response = await axios.post('/comment/create', 
      {
        postId: selectedPost.value.id,
        content: newComment.value.content
      }
    )
    
    if (response.data.code === 200) {
      ElMessage.success('评论成功')
      newComment.value.content = ''
      // 刷新评论和帖子
      await loadComments()
      selectedPost.value.comments += 1
    } else {
      ElMessage.error(response.data.message || '评论失败')
    }
  } catch (error) {
    ElMessage.error('评论失败，请稍后重试')
  } finally {
    commentSubmitting.value = false
  }
}

// 回复评论
const replyComment = (comment) => {
  replyToComment.value = comment
  replyContent.value = ''
  showReplyModal.value = true
}

// 提交回复
const submitReply = async () => {
  if (!replyContent.value.trim() || replySubmitting.value) return

  try {
    replySubmitting.value = true
    
    const response = await axios.post('/comment/reply', 
      {
        postId: selectedPost.value.id,
        content: replyContent.value,
        parentId: replyToComment.value.id,
        replyToUserId: replyToComment.value.userId,
        replyToUsername: replyToComment.value.username
      }
    )
    
    if (response.data.code === 200) {
      ElMessage.success('回复成功')
      showReplyModal.value = false
      // 刷新评论和帖子
      await loadComments()
      selectedPost.value.comments += 1
    } else {
      ElMessage.error(response.data.message || '回复失败')
    }
  } catch (error) {
    ElMessage.error('回复失败，请稍后重试')
  } finally {
    replySubmitting.value = false
  }
}

// 删除评论（管理员）
const deleteComment = async (commentId) => {
  if (!confirm('确定要删除这条评论吗？')) return

  try {
    const response = await axios.post(`/comment/delete/${commentId}`)
    if (response.data.code === 200) {
      ElMessage.success('删除成功')
      // 刷新评论和帖子
      await loadComments()
      selectedPost.value.comments -= 1
    } else {
      ElMessage.error(response.data.message || '删除失败')
    }
  } catch (error) {
    ElMessage.error('删除失败')
  }
}

// 分页
const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadPosts()
  }
}

const changeCommentPage = (page) => {
  if (page >= 1 && page <= commentTotalPages.value) {
    currentCommentPage.value = page
    loadComments()
  }
}

// 查看图片
const viewImage = (img) => {
  currentImage.value = img
  showImageViewer.value = true
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN') + ' ' + date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

// 页面挂载时加载数据
onMounted(() => {
  loadPosts()
})
</script>

<style scoped>
.community {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #4a90e2;
}

.header h1 {
  color: #2c3e50;
  margin: 0;
}

.create-btn {
  background: #27ae60;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 6px;
  cursor: pointer;
  font-weight: bold;
  transition: background 0.3s;
}

.create-btn:hover {
  background: #229954;
}

.search-section {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  display: flex;
  gap: 10px;
}

.search-section input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-section button {
  padding: 10px 20px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.search-section button:hover {
  background: #357abd;
}

.posts-list {
  min-height: 400px;
}

.post-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 15px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.post-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.user-info {
  display: flex;
  gap: 10px;
  align-items: center;
}

.username {
  font-weight: bold;
  color: #2c3e50;
}

.time {
  color: #999;
  font-size: 12px;
}

.post-stats {
  display: flex;
  gap: 15px;
}

.stat {
  color: #666;
  font-size: 13px;
}

.post-content h3 {
  margin: 0 0 8px 0;
  color: #2c3e50;
  font-size: 18px;
}

.post-content p {
  margin: 0 0 10px 0;
  color: #555;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.post-images {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.post-images img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
  cursor: pointer;
  border: 1px solid #ddd;
}

.post-images img:hover {
  border-color: #4a90e2;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin-top: 20px;
}

.pagination button {
  padding: 8px 16px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.pagination button:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  background: white;
  border-radius: 8px;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.post-detail-modal {
  max-width: 800px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
}

.modal-header h2 {
  margin: 0;
  color: #2c3e50;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #999;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  color: #333;
}

.modal-body {
  padding: 20px;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
}

.form-group textarea {
  resize: vertical;
  min-height: 60px;
}

.image-upload input[type="file"] {
  margin-bottom: 10px;
}

.image-preview {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.preview-item {
  position: relative;
  width: 80px;
  height: 80px;
}

.preview-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #ddd;
}

.preview-item button {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  cursor: pointer;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 20px;
}

.cancel-btn {
  padding: 10px 20px;
  background: #95a5a6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.confirm-btn {
  padding: 10px 20px;
  background: #27ae60;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.confirm-btn:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}

.cancel-btn:hover:not(:disabled) {
  background: #7f8c8d;
}

.confirm-btn:hover:not(:disabled) {
  background: #229954;
}

/* 帖子详情样式 */
.post-detail-content {
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid #eee;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
  color: #666;
  font-size: 14px;
  flex-wrap: wrap;
}

.post-meta .username {
  font-weight: bold;
  color: #2c3e50;
}

.post-meta .stats {
  margin-left: auto;
  display: flex;
  gap: 15px;
}

.like-btn {
  cursor: pointer;
  transition: color 0.3s;
}

.like-btn:hover {
  color: #e74c3c;
}

.like-btn.liked {
  color: #e74c3c;
  font-weight: bold;
}

.post-text {
  line-height: 1.8;
  color: #333;
  margin-bottom: 15px;
  white-space: pre-wrap;
}

.post-detail-content .post-images {
  margin-top: 15px;
}

.post-detail-content .post-images img {
  width: 150px;
  height: 150px;
  border-radius: 6px;
}

/* 评论区域 */
.comments-section h3 {
  margin: 0 0 15px 0;
  color: #2c3e50;
  border-bottom: 2px solid #4a90e2;
  padding-bottom: 8px;
}

.comment-input {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.comment-input textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  resize: vertical;
  min-height: 60px;
  font-family: inherit;
}

.comment-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 10px;
}

.submit-comment {
  padding: 8px 16px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
}

.submit-comment:disabled {
  background: #95a5a6;
  cursor: not-allowed;
}

.submit-comment:hover:not(:disabled) {
  background: #357abd;
}

.login-prompt {
  background: #fff3cd;
  padding: 15px;
  border-radius: 6px;
  text-align: center;
  color: #856404;
  margin-bottom: 20px;
}

.login-prompt a {
  color: #664d03;
  font-weight: bold;
  text-decoration: none;
}

.login-prompt a:hover {
  text-decoration: underline;
}

.comments-list {
  min-height: 100px;
}

.comment-item {
  background: #f8f9fa;
  padding: 12px;
  border-radius: 6px;
  margin-bottom: 10px;
  border-left: 3px solid #4a90e2;
}

.comment-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  font-size: 13px;
}

.comment-username {
  font-weight: bold;
  color: #2c3e50;
}

.comment-time {
  color: #999;
}

.comment-content {
  line-height: 1.5;
  color: #333;
  margin-bottom: 8px;
}

.reply-to {
  color: #4a90e2;
  font-weight: bold;
  margin-right: 5px;
}

.comment-actions {
  display: flex;
  gap: 10px;
}

.reply-btn,
.delete-btn {
  padding: 4px 8px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  font-size: 12px;
}

.reply-btn {
  background: #4a90e2;
  color: white;
}

.reply-btn:hover {
  background: #357abd;
}

.delete-btn {
  background: #e74c3c;
  color: white;
}

.delete-btn:hover {
  background: #c0392b;
}

.empty-comments {
  text-align: center;
  padding: 20px;
  color: #999;
}

.comment-pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #eee;
}

.comment-pagination button {
  padding: 6px 12px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.comment-pagination button:disabled {
  background: #95a5a6;
  cursor: not-allowed;
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

/* 响应式调整 */
@media (max-width: 768px) {
  .community {
    padding: 10px;
  }
  
  .header {
    flex-direction: column;
    gap: 10px;
    align-items: flex-start;
  }
  
  .search-section {
    flex-direction: column;
  }
  
  .post-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .post-stats {
    margin-top: 5px;
  }
  
  .modal-content {
    width: 95%;
  }
  
  .post-detail-content .post-images img {
    width: 100px;
    height: 100px;
  }
}
</style>
