package com.shengyouquan.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shengyouquan.common.Result;
import com.shengyouquan.dto.WorkDTO;
import com.shengyouquan.entity.*;
import com.shengyouquan.mapper.*;
import com.shengyouquan.service.StatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员后台Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/admin")
@CrossOrigin
public class AdminController {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private WorkMapper workMapper;
    
    @Autowired
    private CourseMapper courseMapper;
    
    @Autowired
    private OrderMapper orderMapper;
    
    @Autowired
    private PostMapper postMapper;
    
    @Autowired
    private ProductMapper productMapper;
    
    @Autowired
    private StatsService statsService;
    
    @Autowired
    private com.shengyouquan.service.OrderService orderService;
    
    /**
     * 获取管理后台概览数据
     */
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> getDashboard() {
        Map<String, Object> dashboard = new HashMap<>();
        
        // 基础统计
        dashboard.put("userCount", userMapper.selectCount(null));
        dashboard.put("workCount", workMapper.selectCount(null));
        dashboard.put("courseCount", courseMapper.selectCount(null));
        dashboard.put("orderCount", orderMapper.selectCount(null));
        dashboard.put("postCount", postMapper.selectCount(null));
        dashboard.put("productCount", productMapper.selectCount(null));
        
        // 收入统计
        Map<String, Object> incomeStats = statsService.getIncomeStats();
        dashboard.put("incomeStats", incomeStats);
        
        // 最近用户
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.orderByDesc(User::getCreateTime).last("LIMIT 5");
        List<User> recentUsers = userMapper.selectList(userWrapper);
        dashboard.put("recentUsers", recentUsers);
        
        return Result.success(dashboard);
    }
    
    /**
     * 获取用户列表（分页）- 从 sys_user 表查询
     */
    @GetMapping("/users")
    public Result<Map<String, Object>> getUsers(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword) {
        
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(User::getUsername, keyword.trim())
                    .or().like(User::getNickname, keyword.trim())
                    .or().like(User::getPhone, keyword.trim())
                    .or().like(User::getEmail, keyword.trim()));
        }
        wrapper.orderByDesc(User::getCreateTime);
        
        Page<User> pageParam = new Page<>(page, size);
        Page<User> pageResult = userMapper.selectPage(pageParam, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", pageResult.getRecords());
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 获取作品列表（分页）- 包含作者信息
     */
    @GetMapping("/works")
    public Result<Map<String, Object>> getWorks(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        
        Page<WorkDTO> pageParam = new Page<>(page, size);
        Page<WorkDTO> pageResult = workMapper.selectAdminWorkPage(pageParam, status, keyword);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", pageResult.getRecords());
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 审核作品
     */
    @PostMapping("/works/{id}/review")
    public Result<String> reviewWork(@PathVariable Long id, @RequestParam Integer status) {
        Work work = workMapper.selectById(id);
        if (work == null) {
            return Result.error("作品不存在");
        }
        
        work.setStatus(status);
        workMapper.updateById(work);
        
        return Result.success(status == 1 ? "作品已显示" : "作品已隐藏");
    }
    
    /**
     * 删除作品（逻辑删除）
     */
    @DeleteMapping("/works/{id}")
    public Result<String> deleteWork(@PathVariable Long id) {
        Work work = workMapper.selectById(id);
        if (work == null) {
            return Result.error("作品不存在");
        }
        
        // 逻辑删除
        workMapper.deleteById(id);
        
        return Result.success("作品删除成功");
    }
    
    /**
     * 获取课程列表（分页）
     */
    @GetMapping("/courses")
    public Result<Map<String, Object>> getCourses(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword) {
        
        LambdaQueryWrapper<Course> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.and(w -> w.like(Course::getTitle, keyword.trim())
                    .or().like(Course::getDescription, keyword.trim()));
        }
        
        wrapper.orderByDesc(Course::getCreateTime);
        
        Page<Course> pageParam = new Page<>(page, size);
        Page<Course> pageResult = courseMapper.selectPage(pageParam, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", pageResult.getRecords());
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 审核课程（上架/下架）
     */
    @PostMapping("/courses/{id}/review")
    public Result<String> reviewCourse(@PathVariable Long id, @RequestParam Integer status) {
        Course course = courseMapper.selectById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        course.setStatus(status);
        courseMapper.updateById(course);
        
        return Result.success(status == 1 ? "课程已上架" : "课程已下架");
    }
    
    /**
     * 删除课程（逻辑删除）
     */
    @DeleteMapping("/courses/{id}")
    public Result<String> deleteCourse(@PathVariable Long id) {
        Course course = courseMapper.selectById(id);
        if (course == null) {
            return Result.error("课程不存在");
        }
        
        // 逻辑删除
        courseMapper.deleteById(id);
        
        return Result.success("课程删除成功");
    }
    
    /**
     * 获取订单列表（分页）
     */
    @GetMapping("/orders")
    public Result<Map<String, Object>> getOrders(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer payStatus) {
        
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (payStatus != null) {
            wrapper.eq(Order::getPayStatus, payStatus);
        }
        
        wrapper.orderByDesc(Order::getCreateTime);
        
        Page<Order> pageParam = new Page<>(page, size);
        Page<Order> pageResult = orderMapper.selectPage(pageParam, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", pageResult.getRecords());
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 退款订单（管理员操作）
     */
    @PostMapping("/orders/{orderNo}/refund")
    public Result<String> refundOrder(@PathVariable String orderNo) {
        boolean success = orderService.refundOrder(orderNo);
        if (success) {
            return Result.success("订单退款成功");
        } else {
            return Result.error("退款失败，订单不存在或状态不正确");
        }
    }
    
    /**
     * 获取帖子列表（分页）
     */
    @GetMapping("/posts")
    public Result<Map<String, Object>> getPosts(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer status) {
        
        LambdaQueryWrapper<Post> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(Post::getStatus, status);
        }
        
        wrapper.orderByDesc(Post::getCreateTime);
        
        List<Post> posts = postMapper.selectList(wrapper);
        long total = postMapper.selectCount(wrapper);
        
        int from = (page - 1) * size;
        int to = Math.min(from + size, posts.size());
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", posts.subList(Math.max(0, from), to));
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 审核帖子
     */
    @PostMapping("/posts/{id}/review")
    public Result<String> reviewPost(@PathVariable Long id, @RequestParam Integer status) {
        Post post = postMapper.selectById(id);
        if (post == null) {
            return Result.error("帖子不存在");
        }
        
        post.setStatus(status);
        postMapper.updateById(post);
        
        return Result.success("审核成功");
    }
    
    /**
     * 获取商品列表
     */
    @GetMapping("/products")
    public Result<List<Product>> getProducts() {
        List<Product> products = productMapper.selectList(null);
        return Result.success(products);
    }
    
    /**
     * 添加商品
     */
    @PostMapping("/products")
    public Result<String> addProduct(@RequestBody Product product) {
        productMapper.insert(product);
        return Result.success("商品添加成功");
    }
    
    /**
     * 更新商品
     */
    @PutMapping("/products/{id}")
    public Result<String> updateProduct(@PathVariable Long id, @RequestBody Product product) {
        product.setId(id);
        productMapper.updateById(product);
        return Result.success("商品更新成功");
    }
    
    /**
     * 删除商品
     */
    @DeleteMapping("/products/{id}")
    public Result<String> deleteProduct(@PathVariable Long id) {
        productMapper.deleteById(id);
        return Result.success("商品删除成功");
    }
    
    /**
     * 切换用户状态（启用/禁用）
     */
    @PostMapping("/users/{id}/status")
    public Result<String> toggleUserStatus(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 切换状态：1变0，0变1
        user.setStatus(user.getStatus() == 1 ? 0 : 1);
        userMapper.updateById(user);
        
        return Result.success(user.getStatus() == 1 ? "用户已启用" : "用户已禁用");
    }
    
    /**
     * 删除用户（逻辑删除）
     */
    @DeleteMapping("/users/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 防止删除管理员账号
        if ("admin".equals(user.getRole())) {
            return Result.error("不能删除管理员账号");
        }
        
        // 逻辑删除
        userMapper.deleteById(id);
        
        return Result.success("用户删除成功");
    }
}
