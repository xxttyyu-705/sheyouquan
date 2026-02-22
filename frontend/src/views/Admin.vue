<template>
  <div class="admin-container">
    <div class="page-header">
      <h2>管理后台</h2>
    </div>

    <div class="admin-content">
      <el-tabs v-model="activeTab" type="border-card">
        <!-- 用户管理 -->
        <el-tab-pane name="users" label="用户管理">
          <div class="tab-content">
            <div class="toolbar">
              <el-input
                v-model="userFilters.keyword"
                placeholder="搜索用户名、昵称"
                style="width: 300px"
                @input="loadUsers"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
            </div>
            
            <el-table :data="users" v-loading="userLoading" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="username" label="用户名" width="120" />
              <el-table-column prop="nickname" label="昵称" width="120" />
              <el-table-column prop="email" label="邮箱" min-width="180" />
              <el-table-column prop="points" label="积分" width="100" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'danger'">
                    {{ row.status === 1 ? '正常' : '禁用' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="createTime" label="注册时间" width="180" />
              <el-table-column label="操作" width="150" fixed="right">
                <template #default="{ row }">
                  <el-button type="text" size="small" @click="toggleUserStatus(row)">
                    {{ row.status === 1 ? '禁用' : '启用' }}
                  </el-button>
                  <el-button type="text" size="small" @click="deleteUser(row)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <div class="pagination">
              <el-pagination
                v-model:current-page="userPage"
                v-model:page-size="userSize"
                :total="userTotal"
                @current-change="loadUsers"
              />
            </div>
          </div>
        </el-tab-pane>

        <!-- 作品管理 -->
        <el-tab-pane name="works" label="作品管理">
          <div class="tab-content">
            <div class="toolbar">
              <el-input
                v-model="workFilters.keyword"
                placeholder="搜索作品标题"
                style="width: 300px"
                @input="loadWorks"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
              <el-button type="primary" @click="showAddWorkDialog = true">添加作品</el-button>
            </div>
            
            <el-table :data="works" v-loading="workLoading" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="title" label="标题" min-width="150" />
              <el-table-column prop="authorNickname" label="作者" width="120" />
              <el-table-column prop="viewCount" label="浏览" width="80" />
              <el-table-column prop="likeCount" label="点赞" width="80" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'info'">
                    {{ row.status === 1 ? '正常' : '隐藏' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="createTime" label="发布时间" width="180" />
              <el-table-column label="操作" width="150" fixed="right">
                <template #default="{ row }">
                  <el-button type="text" size="small" @click="toggleWorkStatus(row)">
                    {{ row.status === 1 ? '隐藏' : '显示' }}
                  </el-button>
                  <el-button type="text" size="small" @click="deleteWork(row)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <div class="pagination">
              <el-pagination
                v-model:current-page="workPage"
                v-model:page-size="workSize"
                :total="workTotal"
                @current-change="loadWorks"
              />
            </div>
          </div>
        </el-tab-pane>

        <!-- 课程管理 -->
        <el-tab-pane name="courses" label="课程管理">
          <div class="tab-content">
            <div class="toolbar">
              <el-input
                v-model="courseFilters.keyword"
                placeholder="搜索课程标题"
                style="width: 300px"
                @input="loadCourses"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
              <el-button type="primary" @click="showAddCourseDialog = true">添加课程</el-button>
            </div>
            
            <el-table :data="courses" v-loading="courseLoading" style="width: 100%">
              <el-table-column prop="id" label="ID" width="80" />
              <el-table-column prop="title" label="标题" min-width="150" />
              <el-table-column prop="teacherName" label="讲师" width="120" />
              <el-table-column prop="price" label="价格" width="100">
                <template #default="{ row }">
                  {{ row.isFree === 1 ? '免费' : '¥' + row.price }}
                </template>
              </el-table-column>
              <el-table-column prop="studentCount" label="学习人数" width="100" />
              <el-table-column prop="status" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="row.status === 1 ? 'success' : 'info'">
                    {{ row.status === 1 ? '上架' : '下架' }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="150" fixed="right">
                <template #default="{ row }">
                  <el-button type="text" size="small" @click="toggleCourseStatus(row)">
                    {{ row.status === 1 ? '下架' : '上架' }}
                  </el-button>
                  <el-button type="text" size="small" @click="deleteCourse(row)">
                    删除
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <div class="pagination">
              <el-pagination
                v-model:current-page="coursePage"
                v-model:page-size="courseSize"
                :total="courseTotal"
                @current-change="loadCourses"
              />
            </div>
          </div>
        </el-tab-pane>

        <!-- 订单管理 -->
        <el-tab-pane name="orders" label="订单管理">
          <div class="tab-content">
            <div class="toolbar">
              <el-input
                v-model="orderFilters.keyword"
                placeholder="搜索订单号、商品名称"
                style="width: 300px"
                @input="loadOrders"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
              <el-select v-model="orderFilters.status" placeholder="订单状态" clearable @change="loadOrders" style="margin-left: 10px;">
                <el-option label="待支付" :value="0" />
                <el-option label="已支付" :value="1" />
                <el-option label="已取消" :value="2" />
                <el-option label="已退款" :value="3" />
              </el-select>
            </div>
            
            <el-table :data="orders" v-loading="orderLoading" style="width: 100%">
              <el-table-column prop="orderNo" label="订单号" width="180" />
              <el-table-column prop="itemName" label="商品名称" min-width="150" />
              <el-table-column prop="amount" label="金额" width="100">
                <template #default="{ row }">
                  ¥{{ row.amount }}
                </template>
              </el-table-column>
              <el-table-column prop="payType" label="支付方式" width="100">
                <template #default="{ row }">
                  {{ getPayTypeText(row.payType) }}
                </template>
              </el-table-column>
              <el-table-column prop="payStatus" label="状态" width="100">
                <template #default="{ row }">
                  <el-tag :type="getOrderStatusType(row.payStatus)">
                    {{ getOrderStatusText(row.payStatus) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="createTime" label="创建时间" width="180" />
              <el-table-column label="操作" width="120" fixed="right">
                <template #default="{ row }">
                  <el-button 
                    v-if="row.payStatus === 0" 
                    type="text" 
                    size="small" 
                    @click="refundOrder(row)"
                  >
                    退款
                  </el-button>
                </template>
              </el-table-column>
            </el-table>

            <div class="pagination">
              <el-pagination
                v-model:current-page="orderPage"
                v-model:page-size="orderSize"
                :total="orderTotal"
                @current-change="loadOrders"
              />
            </div>
          </div>
        </el-tab-pane>

        <!-- 数据统计 -->
        <el-tab-pane name="stats" label="数据统计">
          <div class="tab-content">
            <div class="stats-grid">
              <div class="stat-card">
                <div class="stat-header">总用户数</div>
                <div class="stat-value">{{ stats.users || 0 }}</div>
                <div class="stat-footer">注册用户总数</div>
              </div>
              <div class="stat-card">
                <div class="stat-header">总作品数</div>
                <div class="stat-value">{{ stats.works || 0 }}</div>
                <div class="stat-footer">已发布作品</div>
              </div>
              <div class="stat-card">
                <div class="stat-header">总课程数</div>
                <div class="stat-value">{{ stats.courses || 0 }}</div>
                <div class="stat-footer">已上架课程</div>
              </div>
              <div class="stat-card">
                <div class="stat-header">总订单数</div>
                <div class="stat-value">{{ stats.orders || 0 }}</div>
                <div class="stat-footer">已完成订单</div>
              </div>
              <div class="stat-card">
                <div class="stat-header">总积分</div>
                <div class="stat-value">{{ stats.totalPoints || 0 }}</div>
                <div class="stat-footer">用户积分总和</div>
              </div>
              <div class="stat-card">
                <div class="stat-header">总收入</div>
                <div class="stat-value">¥{{ stats.totalRevenue || 0 }}</div>
                <div class="stat-footer">订单总收入</div>
              </div>
            </div>

            <div class="charts-section">
              <div class="chart-card">
                <h3>近7天注册用户</h3>
                <div class="chart-placeholder">图表区域（需要集成图表库）</div>
              </div>
              <div class="chart-card">
                <h3>收入趋势</h3>
                <div class="chart-placeholder">图表区域（需要集成图表库）</div>
              </div>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 添加课程对话框 -->
    <el-dialog
      v-model="showAddCourseDialog"
      title="添加课程"
      width="600px"
      @close="resetCourseForm"
    >
      <el-form
        ref="courseFormRef"
        :model="courseForm"
        :rules="courseRules"
        label-width="100px"
      >
        <el-form-item label="课程标题" prop="title">
          <el-input v-model="courseForm.title" placeholder="请输入课程标题" />
        </el-form-item>
        <el-form-item label="课程描述" prop="description">
          <el-input 
            v-model="courseForm.description" 
            type="textarea" 
            :rows="3" 
            placeholder="请输入课程描述"
          />
        </el-form-item>
        <el-form-item label="讲师" prop="teacherName">
          <el-input v-model="courseForm.teacherName" placeholder="请输入讲师姓名" />
        </el-form-item>
        <el-form-item label="分类" prop="category">
          <el-select v-model="courseForm.category" placeholder="选择分类" style="width: 100%">
            <el-option label="基础入门" value="basic" />
            <el-option label="人像摄影" value="portrait" />
            <el-option label="风景摄影" value="landscape" />
            <el-option label="后期处理" value="post" />
            <el-option label="器材使用" value="equipment" />
          </el-select>
        </el-form-item>
        <el-form-item label="难度" prop="difficulty">
          <el-select v-model="courseForm.difficulty" placeholder="选择难度" style="width: 100%">
            <el-option label="入门" :value="1" />
            <el-option label="中级" :value="2" />
            <el-option label="高级" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="时长(分钟)" prop="duration">
          <el-input-number v-model="courseForm.duration" :min="1" style="width: 100%" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="courseForm.price" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="是否免费" prop="isFree">
          <el-radio-group v-model="courseForm.isFree">
            <el-radio :label="0">收费</el-radio>
            <el-radio :label="1">免费</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="封面图" prop="coverImage">
          <el-upload
            action="/file/upload/image"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleCourseCoverSuccess"
            :before-upload="beforeImageUpload"
          >
            <img v-if="courseForm.coverImage" :src="courseForm.coverImage" class="upload-preview" />
            <el-button v-else type="primary" plain>点击上传封面</el-button>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showAddCourseDialog = false">取消</el-button>
          <el-button type="primary" @click="handleAddCourse" :loading="addingCourse">
            确认添加
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import axios from '@/utils/request'

const activeTab = ref('users')

// 用户管理
const users = ref([])
const userLoading = ref(false)
const userPage = ref(1)
const userSize = ref(10)
const userTotal = ref(0)
const userFilters = reactive({
  keyword: ''
})

// 作品管理
const works = ref([])
const workLoading = ref(false)
const workPage = ref(1)
const workSize = ref(10)
const workTotal = ref(0)
const workFilters = reactive({
  keyword: ''
})

// 课程管理
const courses = ref([])
const courseLoading = ref(false)
const coursePage = ref(1)
const courseSize = ref(10)
const courseTotal = ref(0)
const courseFilters = reactive({
  keyword: ''
})
const showAddCourseDialog = ref(false)
const addingCourse = ref(false)
const courseFormRef = ref()

// 订单管理
const orders = ref([])
const orderLoading = ref(false)
const orderPage = ref(1)
const orderSize = ref(10)
const orderTotal = ref(0)
const orderFilters = reactive({
  keyword: '',
  status: null
})

// 统计数据
const stats = ref({})

// 课程表单
const courseForm = reactive({
  title: '',
  description: '',
  teacherName: '',
  category: '',
  difficulty: null,
  duration: 0,
  price: 0,
  isFree: 0,
  coverImage: ''
})

// 课程表单验证规则
const courseRules = {
  title: [
    { required: true, message: '请输入课程标题', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入课程描述', trigger: 'blur' }
  ],
  teacherName: [
    { required: true, message: '请输入讲师姓名', trigger: 'blur' }
  ],
  category: [
    { required: true, message: '请选择课程分类', trigger: 'change' }
  ],
  difficulty: [
    { required: true, message: '请选择难度等级', trigger: 'change' }
  ],
  duration: [
    { required: true, message: '请输入课程时长', trigger: 'blur' }
  ]
}

// 上传headers
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return token ? { Authorization: `Bearer ${token}` } : {}
})

// 加载用户列表
const loadUsers = async () => {
  userLoading.value = true
  try {
    const response = await axios.get('/admin/users', {
      params: {
        page: userPage.value,
        size: userSize.value,
        keyword: userFilters.keyword
      }
    })
    if (response.data.code === 200) {
      users.value = response.data.data.list
      userTotal.value = response.data.data.total
    }
  } catch (error) {
    ElMessage.error('加载用户列表失败')
  } finally {
    userLoading.value = false
  }
}

// 加载作品列表
const loadWorks = async () => {
  workLoading.value = true
  try {
    const response = await axios.get('/work/list', {
      params: {
        page: workPage.value,
        size: workSize.value,
        keyword: workFilters.keyword
      }
    })
    if (response.data.code === 200) {
      works.value = response.data.data.list
      workTotal.value = response.data.data.total
    }
  } catch (error) {
    ElMessage.error('加载作品列表失败')
  } finally {
    workLoading.value = false
  }
}

// 加载课程列表
const loadCourses = async () => {
  courseLoading.value = true
  try {
    const response = await axios.get('/course/list', {
      params: {
        page: coursePage.value,
        size: courseSize.value,
        keyword: courseFilters.keyword
      }
    })
    if (response.data.code === 200) {
      courses.value = response.data.data.list
      courseTotal.value = response.data.data.total
    }
  } catch (error) {
    ElMessage.error('加载课程列表失败')
  } finally {
    courseLoading.value = false
  }
}

// 加载订单列表
const loadOrders = async () => {
  orderLoading.value = true
  try {
    // 模拟数据
    const mockOrders = [
      {
        orderNo: '20240105123456',
        itemName: '人像摄影技巧课程',
        amount: 199,
        payType: 1,
        payStatus: 1,
        createTime: '2024-01-05 14:30:00'
      },
      {
        orderNo: '20240104234567',
        itemName: '摄影技巧手册',
        amount: 800,
        payType: 2,
        payStatus: 0,
        createTime: '2024-01-04 16:45:00'
      }
    ]
    
    orders.value = mockOrders
    orderTotal.value = mockOrders.length
  } catch (error) {
    ElMessage.error('加载订单列表失败')
  } finally {
    orderLoading.value = false
  }
}

// 加载统计数据
const loadStats = async () => {
  try {
    // 模拟数据
    stats.value = {
      users: 156,
      works: 234,
      courses: 12,
      orders: 89,
      totalPoints: 45600,
      totalRevenue: 12580
    }
  } catch (error) {
    ElMessage.error('加载统计数据失败')
  }
}

// 切换用户状态
const toggleUserStatus = async (user) => {
  try {
    // 模拟请求
    await axios.post(`/user/${user.id}/status`)
    
    user.status = user.status === 1 ? 0 : 1
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 删除用户
const deleteUser = async (user) => {
  ElMessageBox.confirm(`确定要删除用户 "${user.username}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await axios.delete(`/user/${user.id}`)
      users.value = users.value.filter(u => u.id !== user.id)
      ElMessage.success('删除成功')
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

// 切换作品状态
const toggleWorkStatus = async (work) => {
  try {
    await axios.post(`/work/${work.id}/status`)
    work.status = work.status === 1 ? 0 : 1
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 删除作品
const deleteWork = async (work) => {
  ElMessageBox.confirm(`确定要删除作品 "${work.title}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await axios.delete(`/work/${work.id}`)
      works.value = works.value.filter(w => w.id !== work.id)
      ElMessage.success('删除成功')
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

// 切换课程状态
const toggleCourseStatus = async (course) => {
  try {
    await axios.post(`/course/${course.id}/status`)
    course.status = course.status === 1 ? 0 : 1
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 删除课程
const deleteCourse = async (course) => {
  ElMessageBox.confirm(`确定要删除课程 "${course.title}" 吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await axios.delete(`/course/${course.id}`)
      courses.value = courses.value.filter(c => c.id !== course.id)
      ElMessage.success('删除成功')
    } catch (error) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

// 退款订单
const refundOrder = async (order) => {
  ElMessageBox.confirm(`确定要为订单 "${order.orderNo}" 退款吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await axios.post(`/order/${order.orderNo}/refund`)
      order.payStatus = 3
      ElMessage.success('退款成功')
    } catch (error) {
      ElMessage.error('退款失败')
    }
  }).catch(() => {})
}

// 课程封面上传成功
const handleCourseCoverSuccess = (response) => {
  if (response.code === 200) {
    courseForm.coverImage = response.data.url
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error(response.message || '封面上传失败')
  }
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

// 添加课程
const handleAddCourse = async () => {
  if (!courseFormRef.value) return
  
  await courseFormRef.value.validate(async (valid) => {
    if (valid) {
      addingCourse.value = true
      try {
        // 模拟添加课程
        await axios.post('/course/create', courseForm)
        
        ElMessage.success('课程添加成功')
        showAddCourseDialog.value = false
        resetCourseForm()
        loadCourses()
      } catch (error) {
        ElMessage.error('添加课程失败')
      } finally {
        addingCourse.value = false
      }
    }
  })
}

// 重置课程表单
function resetCourseForm() {
  courseForm.title = ''
  courseForm.description = ''
  courseForm.teacherName = ''
  courseForm.category = ''
  courseForm.difficulty = null
  courseForm.duration = 0
  courseForm.price = 0
  courseForm.isFree = 0
  courseForm.coverImage = ''
  if (courseFormRef.value) {
    courseFormRef.value.resetFields()
  }
}

// 获取支付方式文本
const getPayTypeText = (type) => {
  const map = {
    1: '微信支付',
    2: '支付宝',
    3: '积分支付'
  }
  return map[type] || '未知'
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
  loadUsers()
})

// 监听activeTab变化
const handleTabChange = (tab) => {
  if (tab === 'users') {
    loadUsers()
  } else if (tab === 'works') {
    loadWorks()
  } else if (tab === 'courses') {
    loadCourses()
  } else if (tab === 'orders') {
    loadOrders()
  } else if (tab === 'stats') {
    loadStats()
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
.admin-container {
  max-width: 1400px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  color: #333;
}

.admin-content {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.tab-content {
  padding: 20px;
  min-height: 500px;
}

.toolbar {
  display: flex;
  gap: 10px;
  margin-bottom: 15px;
  align-items: center;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.upload-preview {
  width: 100%;
  height: 150px;
  object-fit: cover;
  border-radius: 4px;
}

/* 统计卡片样式 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 30px;
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20px;
  border-radius: 8px;
  text-align: center;
}

.stat-card:nth-child(2) {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stat-card:nth-child(3) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stat-card:nth-child(4) {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stat-card:nth-child(5) {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

.stat-card:nth-child(6) {
  background: linear-gradient(135deg, #30cfd0 0%, #330867 100%);
}

.stat-header {
  font-size: 14px;
  opacity: 0.9;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 8px;
}

.stat-footer {
  font-size: 12px;
  opacity: 0.8;
}

/* 图表区域 */
.charts-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 20px;
}

.chart-card {
  background: #f5f7fa;
  padding: 20px;
  border-radius: 8px;
  border: 1px solid #e4e7ed;
}

.chart-card h3 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 16px;
}

.chart-placeholder {
  background: white;
  height: 200px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  border: 2px dashed #e4e7ed;
}
</style>
