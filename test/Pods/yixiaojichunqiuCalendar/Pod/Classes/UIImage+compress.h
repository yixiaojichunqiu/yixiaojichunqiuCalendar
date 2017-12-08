//
//  UIImage+compress.h
//  imggg
//
//  Created by 墨 on 2017/7/12.
//  Copyright © 2017年 墨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (compress)

+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (NSData *)imageCompressForSize:(UIImage *)sourceImage targetPx:(NSInteger)targetPx;

+ (NSData *)imageCompressForSize2:(UIImage *)sourceImage targetPx:(NSInteger)targetPx;

@end
