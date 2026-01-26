package com.shengyouquan.common;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一响应结果类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Data
public class Result<T> implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private Integer code;        // 响应码
    private String message;      // 响应消息
    private T data;              // 响应数据
    private Long timestamp;      // 时间戳
    
    public Result() {
        this.timestamp = System.currentTimeMillis();
    }
    
    public Result(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.timestamp = System.currentTimeMillis();
    }
    
    // 成功响应
    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功", null);
    }
    
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }
    
    public static <T> Result<T> success(String message, T data) {
        return new Result<>(200, message, data);
    }
    
    // 失败响应
    public static <T> Result<T> error() {
        return new Result<>(500, "操作失败", null);
    }
    
    public static <T> Result<T> error(String message) {
        return new Result<>(500, message, null);
    }
    
    public static <T> Result<T> error(Integer code, String message) {
        return new Result<>(code, message, null);
    }
    
    // 自定义响应
    public static <T> Result<T> of(Integer code, String message, T data) {
        return new Result<>(code, message, data);
    }
    
    // 常用响应码
    public static final int SUCCESS_CODE = 200;
    public static final int ERROR_CODE = 500;
    public static final int UNAUTHORIZED_CODE = 401;
    public static final int FORBIDDEN_CODE = 403;
    public static final int NOT_FOUND_CODE = 404;
    public static final int VALIDATION_ERROR_CODE = 400;
    
    // 常用响应消息
    public static final String SUCCESS_MSG = "操作成功";
    public static final String ERROR_MSG = "操作失败";
    public static final String UNAUTHORIZED_MSG = "未授权，请登录";
    public static final String FORBIDDEN_MSG = "无权限访问";
    public static final String NOT_FOUND_MSG = "资源不存在";
    public static final String VALIDATION_ERROR_MSG = "参数验证失败";
}
