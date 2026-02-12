package com.shengyouquan.controller;

import com.shengyouquan.common.Result;
import com.shengyouquan.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

/**
 * 文件上传Controller
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@RestController
@RequestMapping({"/file", "/api/v1/file"})
@CrossOrigin
public class FileController {
    
    @Autowired
    private FileService fileService;
    
    /**
     * 上传图片
     */
    @PostMapping("/upload/image")
    public Result<Map<String, String>> uploadImage(
            @RequestHeader(value = "X-User-Id", required = false) Long userId,
            @RequestParam("file") MultipartFile file) {
        
        try {
            // 如果没有提供用户ID，使用默认值1（用于测试）
            Long actualUserId = userId != null ? userId : 1L;
            String fileUrl = fileService.uploadImage(file, actualUserId);
            return Result.success(Map.of("url", fileUrl));
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 上传多张图片
     */
    @PostMapping("/upload/images")
    public Result<Map<String, String>> uploadImages(
            @RequestHeader(value = "X-User-Id", required = false) Long userId,
            @RequestParam("files") MultipartFile[] files) {
        
        try {
            // 如果没有提供用户ID，使用默认值1（用于测试）
            Long actualUserId = userId != null ? userId : 1L;
            String[] urls = fileService.uploadImages(files, actualUserId);
            return Result.success(Map.of("urls", String.join(",", urls)));
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取文件
     */
    @GetMapping("/{filename:.+}")
    public ResponseEntity<byte[]> getFile(@PathVariable String filename) throws IOException {
        return fileService.getFile(filename);
    }
    
    /**
     * 按日期子目录获取文件（支持 /file/yyyy/MM/dd/xxx.jpg 形式的路径）
     */
    @GetMapping("/{year}/{month}/{day}/{filename:.+}")
    public ResponseEntity<byte[]> getFileByDate(
            @PathVariable String year,
            @PathVariable String month,
            @PathVariable String day,
            @PathVariable String filename) throws IOException {
        
        String path = year + "/" + month + "/" + day + "/" + filename;
        return fileService.getFile(path);
    }
    
    /**
     * 删除文件
     */
    @DeleteMapping("/{filename}")
    public Result<String> deleteFile(
            @RequestHeader("X-User-Id") Long userId,
            @PathVariable String filename) {
        
        try {
            fileService.deleteFile(filename, userId);
            return Result.success("删除成功");
        } catch (Exception e) {
            return Result.error("删除失败: " + e.getMessage());
        }
    }
}
