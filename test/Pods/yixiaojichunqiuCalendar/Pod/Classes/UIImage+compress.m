//
//  UIImage+compress.m
//  imggg
//
//  Created by 墨 on 2017/7/12.
//  Copyright © 2017年 墨. All rights reserved.
//

#import "UIImage+compress.h"

@implementation UIImage (compress)
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //        NSLog(@"Compression = %.1f", compression);
        //        NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //      NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
            NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //    NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx {
    NSData* newdata=UIImageJPEGRepresentation(sourceImage, 0.8);
    if (newdata.length<400*1024) {
        return newdata;
    }
    UIImage *newImage = nil;             // 尺寸压缩后的新图
    CGSize imageSize = sourceImage.size; // 源图片的size
    CGFloat width = imageSize.width;     // 源图片的宽
    CGFloat height = imageSize.height;   // 原图片的高
    BOOL drawImge = NO;     // 是否需要重绘图片 默认是NO
    CGFloat scaleFactor = 0.0;           // 压缩比例
    CGFloat scaledWidth = targetPx;      // 压缩时的宽度 默认是参照像素
    CGFloat scaledHeight = targetPx;     // 压缩是的高度 默认是参照像素
    
    // 先进行图片的尺寸的判断
    
    // a.图片宽高均≤参照像素时，图片尺寸保持不变
    if (width < targetPx && height < targetPx) {
        newImage = sourceImage;
    }  else if (width > targetPx && height > targetPx) {
        // b.宽或高均＞1280px时
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {
            // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            scaleFactor = width > height ? targetPx / width : targetPx / height;
        } else {
            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            scaleFactor = width > height ? targetPx / height : targetPx / width;
        }
    } else if (width > targetPx &&  height < targetPx ) {
        // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
        if (width / height > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / width;
        }
    } else if (width < targetPx &&  height > targetPx) {
        // c.宽高一个＞1280px，另一个＜1280px 高大于1280
        if (height / width > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / height;
        }
    }
    
    // 如果图片需要重绘 就按照新的宽高压缩重绘图片
    if (drawImge == YES) {
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        // 绘制改变大小的图片
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        // 从当前context中创建一个改变大小后的图片
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 防止出错  可以删掉的
    if (newImage == nil) {
        newImage = sourceImage;
    }
    
    // 如果图片大小大于200kb 在进行质量上压缩
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil) {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        
        if (scaledImageData.length >= 1024 * 200) {
            scaledImageData =   UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    
    return scaledImageData;
}


+ (NSData *)imageCompressForSize2:(UIImage *)sourceImage targetPx:(NSInteger)targetPx {
    NSData* newdata=UIImageJPEGRepresentation(sourceImage, 0.8);

    UIImage *newImage = nil;             // 尺寸压缩后的新图
    CGSize imageSize = sourceImage.size; // 源图片的size
    CGFloat width = imageSize.width;     // 源图片的宽
    CGFloat height = imageSize.height;   // 原图片的高
    BOOL drawImge = NO;     // 是否需要重绘图片 默认是NO
    CGFloat scaleFactor = 0.0;           // 压缩比例
    CGFloat scaledWidth = targetPx;      // 压缩时的宽度 默认是参照像素
    CGFloat scaledHeight = targetPx;     // 压缩是的高度 默认是参照像素
    
    // 先进行图片的尺寸的判断
    
    // a.图片宽高均≤参照像素时，图片尺寸保持不变
    if (width < targetPx && height < targetPx) {
        newImage = sourceImage;
    }  else if (width > targetPx && height > targetPx) {
        // b.宽或高均＞1280px时
        drawImge = YES;
        CGFloat factor = width / height;
        if (factor <= 2) {
            // b.1图片宽高比≤2，则将图片宽或者高取大的等比压缩至1280px
            scaleFactor = width > height ? targetPx / width : targetPx / height;
        } else {
            // b.2图片宽高比＞2时，则宽或者高取小的等比压缩至1280px
            scaleFactor = width > height ? targetPx / height : targetPx / width;
        }
    } else if (width > targetPx &&  height < targetPx ) {
        // c.宽高一个＞1280px，另一个＜1280px 宽大于1280
        if (width / height > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / width;
        }
    } else if (width < targetPx &&  height > targetPx) {
        // c.宽高一个＞1280px，另一个＜1280px 高大于1280
        if (height / width > 2) {
            newImage = sourceImage;
        } else {
            drawImge = YES;
            scaleFactor = targetPx / height;
        }
    }
    
    // 如果图片需要重绘 就按照新的宽高压缩重绘图片
    if (drawImge == YES) {
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        // 绘制改变大小的图片
        [sourceImage drawInRect:CGRectMake(0, 0, scaledWidth,scaledHeight)];
        // 从当前context中创建一个改变大小后的图片
        newImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    // 防止出错  可以删掉的
    if (newImage == nil) {
        newImage = sourceImage;
    }
    
    // 如果图片大小大于200kb 在进行质量上压缩
    NSData * scaledImageData = nil;
    if (UIImageJPEGRepresentation(newImage, 1) == nil) {
        scaledImageData = UIImagePNGRepresentation(newImage);
    }else{
        scaledImageData = UIImageJPEGRepresentation(newImage, 1);
        
        if (scaledImageData.length >= 1024 * 200) {
            scaledImageData =   UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    
    return scaledImageData;
}

@end
