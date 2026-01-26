package com.shengyouquan.service;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 文件服务类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */
@Service
public class FileService {
    
    private static final String UPLOAD_BASE_PATH = "uploads/";
    private static final String[] ALLOWED_IMAGE_TYPES = {".jpg", ".jpeg", ".png", ".gif", ".bmp"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    /**
     * 上传单张图片
     */
    public String uploadImage(MultipartFile file, Long userId) throws IOException {
        validateFile(file);
        
        String datePath = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
        File uploadDir = new File(UPLOAD_BASE_PATH + datePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        String fileName = UUID.randomUUID().toString() + extension;
        String filePath = uploadDir.getAbsolutePath() + File.separator + fileName;
        
        File dest = new File(filePath);
        file.transferTo(dest);
        
        return "/api/file/" + datePath + "/" + fileName;
    }
    
    /**
     * 上传多张图片
     */
    public String[] uploadImages(MultipartFile[] files, Long userId) throws IOException {
        List<String> urls = new ArrayList<>();
        for (MultipartFile file : files) {
            String url = uploadImage(file, userId);
            urls.add(url);
        }
        return urls.toArray(new String[0]);
    }
    
    /**
     * 获取文件
     */
    public ResponseEntity<byte[]> getFile(String filename) throws IOException {
        String filePath = UPLOAD_BASE_PATH + filename;
        File file = new File(filePath);
        
        if (!file.exists()) {
            throw new IOException("文件不存在");
        }
        
        byte[] fileContent = Files.readAllBytes(file.toPath());
        String contentType = Files.probeContentType(file.toPath());
        
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getName() + "\"")
                .body(fileContent);
    }
    
    /**
     * 删除文件
     */
    public void deleteFile(String filename, Long userId) throws IOException {
        String filePath = UPLOAD_BASE_PATH + filename;
        File file = new File(filePath);
        
        if (file.exists()) {
            if (!file.delete()) {
                throw new IOException("删除文件失败");
            }
        }
    }
    
    /**
     * 验证文件
     */
    private void validateFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IOException("文件不能为空");
        }
        
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IOException("文件大小不能超过5MB");
        }
        
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || !originalFilename.contains(".")) {
            throw new IOException("文件格式不正确");
        }
        
        String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        boolean isValidType = false;
        for (String allowedType : ALLOWED_IMAGE_TYPES) {
            if (allowedType.equals(extension)) {
                isValidType = true;
                break;
            }
        }
        
        if (!isValidType) {
            throw new IOException("只允许上传图片文件");
        }
    }
    
    /**
     * 获取文件访问URL
     */
    public String getFileUrl(String filePath) {
        return "/api/file/" + filePath;
    }
}
