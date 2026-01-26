package com.shengyouquan.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shengyouquan.entity.Product;
import com.shengyouquan.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 商品服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class ProductService extends ServiceImpl<ProductMapper, Product> {
    
    @Autowired
    private ProductMapper productMapper;
    
    /**
     * 分页查询商品列表
     */
    public Map<String, Object> getProducts(String keyword, String category, Integer page, Integer size) {
        Page<Product> pageObj = new Page<>(page, size);
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        
        wrapper.eq(Product::getStatus, 1); // 只显示上架商品
        
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Product::getName, keyword);
        }
        
        if (category != null && !category.isEmpty()) {
            wrapper.eq(Product::getCategory, category);
        }
        
        wrapper.orderByDesc(Product::getCreateTime);
        
        Page<Product> resultPage = productMapper.selectPage(pageObj, wrapper);
        
        Map<String, Object> result = new HashMap<>();
        result.put("list", resultPage.getRecords());
        result.put("total", resultPage.getTotal());
        result.put("pages", resultPage.getPages());
        
        return result;
    }
    
    /**
     * 获取商品详情
     */
    public Product getProductDetail(Long id) {
        return productMapper.selectById(id);
    }
    
    /**
     * 添加商品
     */
    @Transactional
    public boolean addProduct(Product product) {
        product.setCreateTime(LocalDateTime.now());
        product.setUpdateTime(LocalDateTime.now());
        return productMapper.insert(product) > 0;
    }
    
    /**
     * 更新商品
     */
    @Transactional
    public boolean updateProduct(Product product) {
        product.setUpdateTime(LocalDateTime.now());
        return productMapper.updateById(product) > 0;
    }
    
    /**
     * 更新商品状态
     */
    @Transactional
    public boolean updateProductStatus(Long id, Integer status) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            return false;
        }
        product.setStatus(status);
        product.setUpdateTime(LocalDateTime.now());
        return productMapper.updateById(product) > 0;
    }
    
    /**
     * 扣减库存
     */
    @Transactional
    public boolean deductStock(Long id, Integer quantity) {
        Product product = productMapper.selectById(id);
        if (product == null || product.getStock() < quantity) {
            return false;
        }
        
        product.setStock(product.getStock() - quantity);
        product.setUpdateTime(LocalDateTime.now());
        
        return productMapper.updateById(product) > 0;
    }
}
