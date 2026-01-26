package com.shengyouquan;

import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 摄友圈社区系统启动类
 * 
 * @author 摄友圈开发团队
 * @since 1.0.0
 */

@SpringBootApplication
@EnableTransactionManagement
public class ShengYouQuanApplication {

    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(ShengYouQuanApplication.class);
        app.setBannerMode(Banner.Mode.OFF); // 可选：关闭banner
        app.run(args);
        System.out.println("=================================");
        System.out.println("摄友圈社区系统启动成功！");
        System.out.println("API文档地址: http://localhost:8081/swagger-ui.html");
        System.out.println("=================================");
    }
}
