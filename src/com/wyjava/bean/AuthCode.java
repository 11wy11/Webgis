package com.wyjava.bean;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;

public class AuthCode {
	private ByteArrayInputStream input;  
    private ByteArrayOutputStream output;  
    private String code;// 验证码  
    private int codeNum;// 验证码字符数量  
  
    private int width;  
    private int height;  
  
    // 构造器  
    private AuthCode(int width, int height, int codeNum) {  
        this.width = width;  
        this.height = height;  
        this.codeNum = codeNum;  
  
        if (width < 15 * codeNum + 6) {  
            this.width = 13 * codeNum + 6;  
        }  
        if (height < 20) {  
            this.height = 20;  
        }  
  
        buildImage();  
    }  
  
    // 以字符串形式返回验证码  
    public String getCode() {  
        return code;  
    }  
  
    // 以输入流的形式返回验证图片  
    public ByteArrayInputStream getIamgeAsInputStream() {  
        return input;  
    }  
  
    // 以输出流的形式返回验证图片  
    public ByteArrayOutputStream getImageAsOuputStream() {  
        return output;  
    }  
  
    // 创建默认大小的验证码  
    public static AuthCode createInstance() {  
        return new AuthCode(85, 20, 4);  
    }  
  
    // 创建指定大小的验证码  
    public static AuthCode createInstance(int width, int height, int codeNum) {  
        return new AuthCode(width, height, codeNum);  
    }  
  
    // 生成验证码图片  
    private void buildImage() {  
  
        BufferedImage image = new BufferedImage(width, height,  
                BufferedImage.TYPE_INT_RGB);  
        // 获取图形上下文  
        Graphics g = image.getGraphics();  
        // 生成随机类  
        Random random = new Random();  
        // 设定背景色  
        g.setColor(getRandColor(200, 250));  
        g.fillRect(0, 0, width, height);  
        // 设定字体  
        g.setFont(new Font("Times New Roman", Font.PLAIN, 18));  
          
        // 随机产生150条干扰线，使图象中的认证码不易被其它程序探测到  
        g.setColor(getRandColor(160, 200));  
        for (int i = 0; i < 150; i++) {  
            int x = random.nextInt(width);  
            int y = random.nextInt(height);  
            int xl = random.nextInt(12);  
            int yl = random.nextInt(12);  
            g.drawLine(x, y, x + xl, y + yl);  
        }  
  
        // 取随机产生的认证码  
        String codes = "ABCDEFGHJKLMNOPQRSTUVWXYZ23456789";  
        String sRand = "";  
        for (int i = 0; i < codeNum; i++) {  
            String rand = codes.charAt(random.nextInt(codes.length())) + "";  
            sRand += rand;  
              
            // 将认证码显示到图象中  
            g.setColor(new Color(20 + random.nextInt(110), 20 + random  
                    .nextInt(110), 20 + random.nextInt(110)));  
              
            // 将字符串绘制到图片上  
            g.drawString(rand, i * (width / codeNum) + 6, (int)((height+12)/2));  
        }  
  
        /* 验证码赋值 */  
        this.code = sRand;  
          
        // 图象生效  
        g.dispose();  
  
        try {  
            output = new ByteArrayOutputStream();  
            ImageOutputStream imageOut = ImageIO  
                    .createImageOutputStream(output);  
            ImageIO.write(image, "JPEG", imageOut);  
            imageOut.close();  
            input = new ByteArrayInputStream(output.toByteArray());  
        } catch (Exception e) {  
            System.out.println("验证码图片产生出现错误：" + e.toString());  
        }  
    }
 // 获取随机颜色  
    private Color getRandColor(int fc, int bc) {  
        Random random = new Random();  
        if (fc > 255)  
            fc = 255;  
        if (bc > 255)  
            bc = 255;  
  
        int r = fc + random.nextInt(bc - fc);  
        int g = fc + random.nextInt(bc - fc);  
        int b = fc + random.nextInt(bc - fc);  
  
        return new Color(r, g, b);  
    }  
  
    
}
