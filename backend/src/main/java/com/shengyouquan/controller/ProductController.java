package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.entity.Product;
import com.shengyouquan.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 商品Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping("/product")
@CrossOrigin
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    /**
     * 获取商品列表
     */
    @GetMapping("/list")
    public Result<Map<String, Object>> getProducts(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "12") Integer size) {
        Map<String, Object> products = productService.getProducts(keyword, category, page, size);
        return Result.success(products);
    }
    
    /**
     * 获取商品详情
     */
    @GetMapping("/detail/{id}")
    public Result<Product> getProductDetail(@PathVariable Long id) {
        Product product = productService.getProductDetail(id);
        if (product == null) {
            return Result.error("商品不存在");
        }
        return Result.success(product);
    }
    
    /**
     * 添加商品（管理员）
     */
    @PostMapping("/add")
    public Result<String> addProduct(@RequestBody Product product) {
        if (productService.addProduct(product)) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }
    
    /**
     * 更新商品（管理员）
     */
    @PostMapping("/update")
    public Result<String> updateProduct(@RequestBody Product product) {
        if (productService.updateProduct(product)) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }
    
    /**
     * 更新商品状态（管理员）
     */
    @PostMapping("/status/{id}")
    public Result<String> updateProductStatus(@PathVariable Long id, @RequestParam Integer status) {
        if (productService.updateProductStatus(id, status)) {
            return Result.success("状态更新成功");
        }
        return Result.error("状态更新失败");
    }
}
