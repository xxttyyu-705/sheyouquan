package com.shengyouquan.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shengyouquan.common.Result;
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
     * 获取用户列表（分页）
     */
    @GetMapping("/users")
    public Result<Map<String, Object>> getUsers(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String keyword) {
        
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(User::getUsername, keyword)
                   .or().like(User::getNickname, keyword)
                   .or().like(User::getPhone, keyword);
        }
        
        wrapper.orderByDesc(User::getCreateTime);
        
        List<User> users = userMapper.selectList(wrapper);
        long total = userMapper.selectCount(wrapper);
        
        // 分页
        int from = (page - 1) * size;
        int to = Math.min(from + size, users.size());
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", users.subList(Math.max(0, from), to));
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
    }
    
    /**
     * 获取作品列表（分页）
     */
    @GetMapping("/works")
    public Result<Map<String, Object>> getWorks(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String status) {
        
        LambdaQueryWrapper<Work> wrapper = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Work::getStatus, Integer.parseInt(status));
        }
        
        wrapper.orderByDesc(Work::getCreateTime);
        
        List<Work> works = workMapper.selectList(wrapper);
        long total = workMapper.selectCount(wrapper);
        
        int from = (page - 1) * size;
        int to = Math.min(from + size, works.size());
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", works.subList(Math.max(0, from), to));
        result.put("total", total);
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
        
        return Result.success("审核成功");
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
        
        List<Order> orders = orderMapper.selectList(wrapper);
        long total = orderMapper.selectCount(wrapper);
        
        int from = (page - 1) * size;
        int to = Math.min(from + size, orders.size());
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", orders.subList(Math.max(0, from), to));
        result.put("total", total);
        result.put("page", page);
        result.put("size", size);
        
        return Result.success(result);
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
}
