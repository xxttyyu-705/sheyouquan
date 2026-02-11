<template>
  <div class="mall">
    <header class="header">
      <h1>积分商城</h1>
      <div class="user-points" v-if="userStore.isLoggedIn">
        <span class="points">我的积分: {{ userPoints }}</span>
      </div>
    </header>

    <!-- 筛选区域 -->
    <div class="filter-section">
      <div class="search-box">
        <input 
          v-model="searchKeyword" 
          placeholder="搜索商品..." 
          @keyup.enter="loadProducts"
        />
        <button @click="loadProducts">搜索</button>
      </div>
      <div class="category-filter">
        <span 
          v-for="cat in categories" 
          :key="cat.value"
          :class="{ active: currentCategory === cat.value }"
          @click="selectCategory(cat.value)"
        >
          {{ cat.label }}
        </span>
      </div>
    </div>

    <!-- 商品列表 -->
    <div class="products-grid" v-loading="loading">
      <div 
        v-for="product in products" 
        :key="product.id" 
        class="product-card"
        @click="showProductDetail(product)"
      >
        <div class="product-image">
          <img :src="product.coverImage || '/default-product.png'" :alt="product.name" />
          <div class="stock-badge" v-if="product.stock <= 0">已售罄</div>
        </div>
        <div class="product-info">
          <h3>{{ product.name }}</h3>
          <p class="desc">{{ product.description }}</p>
          <div class="price-section">
            <span class="points">{{ product.price }} 积分</span>
            <span class="stock">库存: {{ product.stock }}</span>
          </div>
          <button 
            class="exchange-btn" 
            :disabled="product.stock <= 0"
            @click.stop="showExchangeDialog(product)"
          >
            立即兑换
          </button>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-if="products.length === 0 && !loading" class="empty-state">
      <p>暂无商品</p>
    </div>

    <!-- 分页 -->
    <div class="pagination" v-if="totalPages > 1">
      <button 
        :disabled="currentPage === 1" 
        @click="changePage(currentPage - 1)"
      >
        上一页
      </button>
      <span>{{ currentPage }} / {{ totalPages }}</span>
      <button 
        :disabled="currentPage === totalPages" 
        @click="changePage(currentPage + 1)"
      >
        下一页
      </button>
    </div>

    <!-- 商品详情弹窗 -->
    <div v-if="showDetail" class="modal-overlay" @click="showDetail = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>{{ selectedProduct?.name }}</h2>
          <button class="close-btn" @click="showDetail = false">×</button>
        </div>
        <div class="modal-body">
          <div class="product-detail-image">
            <img :src="selectedProduct?.coverImage || '/default-product.png'" :alt="selectedProduct?.name" />
          </div>
          <div class="product-detail-info">
            <p class="description">{{ selectedProduct?.description }}</p>
            <div class="detail-price">
              <span class="points">{{ selectedProduct?.price }} 积分</span>
              <span class="stock">库存: {{ selectedProduct?.stock }}</span>
            </div>
            <div class="detail-category">分类: {{ selectedProduct?.categoryId }}</div>
            <button 
              class="exchange-btn" 
              :disabled="selectedProduct?.stock <= 0"
              @click="showExchangeDialog(selectedProduct)"
            >
              立即兑换
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 兑换弹窗 -->
    <div v-if="showExchange" class="modal-overlay" @click="showExchange = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>确认兑换</h2>
          <button class="close-btn" @click="showExchange = false">×</button>
        </div>
        <div class="modal-body">
          <div class="exchange-summary">
            <h3>{{ exchangeProduct?.name }}</h3>
            <p>所需积分: <strong>{{ exchangeProduct?.price }} 分</strong></p>
            <p>当前积分: <strong>{{ userPoints }} 分</strong></p>
            <p v-if="userPoints < exchangeProduct?.price" class="error-text">
              积分不足！
            </p>
          </div>
          
          <div class="exchange-form">
            <div class="form-group">
              <label>收货地址:</label>
              <input 
                v-model="exchangeForm.address" 
                type="text" 
                placeholder="请输入详细收货地址"
                required
              />
            </div>
            <div class="form-group">
              <label>联系电话:</label>
              <input 
                v-model="exchangeForm.phone" 
                type="tel" 
                placeholder="请输入联系电话"
                required
              />
            </div>
            <div class="form-group">
              <label>备注 (可选):</label>
              <textarea 
                v-model="exchangeForm.remark" 
                placeholder="如有特殊要求，请在此说明"
              ></textarea>
            </div>
          </div>

          <div class="modal-actions">
            <button class="cancel-btn" @click="showExchange = false">取消</button>
            <button 
              class="confirm-btn" 
              :disabled="!canExchange || submitting"
              @click="submitExchange"
            >
              {{ submitting ? '提交中...' : '确认兑换' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 我的兑换记录 -->
    <div class="exchange-records" v-if="userStore.isLoggedIn">
      <h2>我的兑换记录</h2>
      <div class="records-list" v-loading="recordsLoading">
        <div 
          v-for="record in exchangeRecords" 
          :key="record.id" 
          class="record-item"
        >
          <div class="record-info">
            <h4>{{ record.productName }}</h4>
            <p class="record-meta">
              <span>{{ record.points }} 积分</span>
              <span>{{ formatDate(record.createTime) }}</span>
              <span class="status" :class="'status-' + record.status">
                {{ getStatusText(record.status) }}
              </span>
            </p>
            <p class="record-address" v-if="record.address">
              {{ record.address }} - {{ record.phone }}
            </p>
            <p class="record-remark" v-if="record.remark">
              备注: {{ record.remark }}
            </p>
          </div>
        </div>
        <div v-if="exchangeRecords.length === 0" class="empty-records">
          暂无兑换记录
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useUserStore } from '../stores/user'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const userStore = useUserStore()

// 商品数据
const products = ref([])
const loading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)
const total = ref(0)
const searchKeyword = ref('')
const currentCategory = ref('')

// 选中的商品
const selectedProduct = ref(null)
const showDetail = ref(false)

// 兑换相关
const showExchange = ref(false)
const exchangeProduct = ref(null)
const exchangeForm = ref({
  address: '',
  phone: '',
  remark: ''
})
const submitting = ref(false)

// 用户积分
const userPoints = ref(0)

// 兑换记录
const exchangeRecords = ref([])
const recordsLoading = ref(false)

// 分类选项（对应数据库category_id）
const categories = [
  { label: '全部', value: '' },
  { label: '摄影器材', value: '1' },
  { label: '三脚架', value: '2' },
  { label: '电子书', value: '3' }
]

// 计算属性
const canExchange = computed(() => {
  return exchangeForm.value.address && 
         exchangeForm.value.phone && 
         exchangeProduct.value &&
         userPoints.value >= exchangeProduct.value.price
})

// 加载商品列表
const loadProducts = async () => {
  try {
    loading.value = true
    const params = {
      page: currentPage.value,
      size: 12,
      keyword: searchKeyword.value,
      category: currentCategory.value
    }
    
    const response = await axios.get('/product/list', { params })
    if (response.data.code === 200) {
      products.value = response.data.data.list
      totalPages.value = response.data.data.pages
      total.value = response.data.data.total
    }
  } catch (error) {
    ElMessage.error('加载商品失败')
  } finally {
    loading.value = false
  }
}

// 加载用户积分
const loadUserPoints = async () => {
  if (!userStore.isLoggedIn) return
  
  try {
    const response = await axios.get('/point/balance')
    if (response.data.code === 200) {
      userPoints.value = response.data.data
    }
  } catch (error) {
    console.error('加载积分失败:', error)
  }
}

// 加载兑换记录
const loadExchangeRecords = async () => {
  if (!userStore.isLoggedIn) return
  
  try {
    recordsLoading.value = true
    const response = await axios.get('/exchange/list', {
      params: { page: 1, size: 10 }
    })
    if (response.data.code === 200) {
      exchangeRecords.value = response.data.data.list
    }
  } catch (error) {
    ElMessage.error('加载兑换记录失败')
  } finally {
    recordsLoading.value = false
  }
}

// 选择分类
const selectCategory = (category) => {
  currentCategory.value = category
  currentPage.value = 1
  loadProducts()
}

// 分页
const changePage = (page) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadProducts()
  }
}

// 显示商品详情
const showProductDetail = (product) => {
  selectedProduct.value = product
  showDetail.value = true
}

// 显示兑换弹窗
const showExchangeDialog = (product) => {
  
  exchangeProduct.value = product
  showExchange.value = true
}

// 提交兑换
const submitExchange = async () => {
  if (!canExchange.value || submitting.value) return
  
  try {
    submitting.value = true
    
    const response = await axios.post('/exchange/create', 
      {
        productId: exchangeProduct.value.id,
        address: exchangeForm.value.address,
        phone: exchangeForm.value.phone,
        remark: exchangeForm.value.remark
      }
    )
    
    if (response.data.code === 200) {
      ElMessage.success('兑换成功！')
      showExchange.value = false
      // 重置表单
      exchangeForm.value = { address: '', phone: '', remark: '' }
      // 刷新数据
      loadProducts()
      loadUserPoints()
      loadExchangeRecords()
    } else {
      ElMessage.error(response.data.message || '兑换失败')
    }
  } catch (error) {
    ElMessage.error('兑换失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN') + ' ' + date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

// 获取状态文本
const getStatusText = (status) => {
  const statusMap = {
    0: '待处理',
    1: '已发货',
    2: '已完成',
    3: '已取消'
  }
  return statusMap[status] || '未知'
}

// 页面挂载时加载数据
onMounted(() => {
  loadProducts()
  if (userStore.isLoggedIn) {
    loadUserPoints()
    loadExchangeRecords()
  }
})
</script>

<style scoped>
.mall {
  padding: 20px;
  max-width: 1200px;
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

.user-points {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: bold;
}

.filter-section {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.search-box {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
}

.search-box input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.search-box button {
  padding: 10px 20px;
  background: #4a90e2;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.search-box button:hover {
  background: #357abd;
}

.category-filter {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.category-filter span {
  padding: 6px 12px;
  border: 1px solid #ddd;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.3s;
  font-size: 14px;
}

.category-filter span:hover {
  border-color: #4a90e2;
  color: #4a90e2;
}

.category-filter span.active {
  background: #4a90e2;
  color: white;
  border-color: #4a90e2;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.product-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.3s, box-shadow 0.3s;
  cursor: pointer;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.product-image {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f5f5f5;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.stock-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(255, 0, 0, 0.8);
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
}

.product-info {
  padding: 15px;
}

.product-info h3 {
  margin: 0 0 8px 0;
  color: #2c3e50;
  font-size: 16px;
}

.desc {
  color: #666;
  font-size: 13px;
  margin: 0 0 10px 0;
  line-height: 1.4;
  height: 2.8em;
  overflow: hidden;
}

.price-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.points {
  color: #e74c3c;
  font-weight: bold;
  font-size: 16px;
}

.stock {
  color: #999;
  font-size: 12px;
}

.exchange-btn {
  width: 100%;
  padding: 8px;
  background: #27ae60;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
  transition: background 0.3s;
}

.exchange-btn:hover:not(:disabled) {
  background: #229954;
}

.exchange-btn:disabled {
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

.product-detail-image {
  width: 100%;
  height: 300px;
  background: #f5f5f5;
  margin-bottom: 20px;
  border-radius: 8px;
  overflow: hidden;
}

.product-detail-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-detail-info .description {
  color: #666;
  line-height: 1.6;
  margin-bottom: 15px;
}

.detail-price {
  display: flex;
  gap: 20px;
  margin-bottom: 10px;
}

.detail-category {
  color: #999;
  margin-bottom: 15px;
}

.exchange-summary {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 6px;
  margin-bottom: 20px;
}

.exchange-summary h3 {
  margin: 0 0 10px 0;
  color: #2c3e50;
}

.exchange-summary p {
  margin: 5px 0;
  color: #555;
}

.error-text {
  color: #e74c3c !important;
  font-weight: bold;
}

.exchange-form {
  margin-bottom: 20px;
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

.modal-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
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

/* 兑换记录 */
.exchange-records {
  margin-top: 40px;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.exchange-records h2 {
  margin: 0 0 20px 0;
  color: #2c3e50;
  border-bottom: 2px solid #4a90e2;
  padding-bottom: 10px;
}

.records-list {
  min-height: 100px;
}

.record-item {
  padding: 15px;
  border-bottom: 1px solid #eee;
  background: #fafafa;
  margin-bottom: 10px;
  border-radius: 6px;
}

.record-item:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.record-info h4 {
  margin: 0 0 8px 0;
  color: #2c3e50;
}

.record-meta {
  display: flex;
  gap: 15px;
  margin: 0 0 8px 0;
  font-size: 13px;
  color: #666;
  flex-wrap: wrap;
}

.status {
  font-weight: bold;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-0 {
  background: #fff3cd;
  color: #856404;
}

.status-1 {
  background: #d1ecf1;
  color: #0c5460;
}

.status-2 {
  background: #d4edda;
  color: #155724;
}

.status-3 {
  background: #f8d7da;
  color: #721c24;
}

.record-address,
.record-remark {
  margin: 0;
  font-size: 12px;
  color: #666;
}

.empty-records {
  text-align: center;
  padding: 20px;
  color: #999;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .products-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 15px;
  }
  
  .modal-content {
    width: 95%;
  }
  
  .record-meta {
    flex-direction: column;
    gap: 4px;
  }
}
</style>
