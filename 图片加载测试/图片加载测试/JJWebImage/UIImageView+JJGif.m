//
//  UIImageView+JJGif.m
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "UIImageView+JJGif.h"
#import <ImageIO/ImageIO.h>
#import <objc/runtime.h>

#define weak(obj)   __weak typeof(obj) weakSelf = obj
#define strong(obj) __strong typeof(weakSelf) obj = weakSelf
@implementation UIImageView (JJGif)

// 判断是否是gif图片
- (BOOL)is_gif:(NSURL *)url
{
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    if (count != 0) {
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        self.jj_imageWidth = width;
        self.jj_imageHeight = height;
    }
    
    if (source) CFRelease(source);
    if (count > 1) {
        return YES;
    }
    return NO;
}
// 加载gif图片
- (void)jj_getGIFWithUrl:(NSURL *)url
{
    // 获取url下图片的数据源
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    // 计算数据源中图片的个数
    size_t count = CGImageSourceGetCount(source);
    // 初始化总时间
    float allTime=0;
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //遍历数据源数组
    for (size_t i=0; i<count; i++) {
        
        // 获取数据源中每一张图片
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *jw_img = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [imageArray addObject:jw_img];
        // 释放图片(这里用完需要释放,否则会内存泄露)
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        // 获取到这一帧所用到的时间
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        // 释放图片信息属性(如果不释放,会内存泄露)
        CFRelease((__bridge CFTypeRef)(info));
    }
    // 释放图片的数据源
    if (source) CFRelease(source);
    
    // 展示一定要在主线程,否则会卡顿
    weak(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        strong(self);
        self.image = [UIImage animatedImageWithImages:imageArray duration:allTime];
    });
}
// 加载本地gif图片
- (void)jj_getLocationGIFWithContentFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 获取url下图片的数据源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    // 计算数据源中图片的个数
    size_t count = CGImageSourceGetCount(source);
    // 初始化总时间
    float allTime=0;
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //遍历数据源数组
    for (size_t i=0; i<count; i++) {
        
        // 获取数据源中每一张图片
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *jw_img = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [imageArray addObject:jw_img];
        // 释放图片(这里用完需要释放,否则会内存泄露)
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        // 获取到这一帧所用到的时间
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        // 释放图片信息属性(如果不释放,会内存泄露)
        CFRelease((__bridge CFTypeRef)(info));
    }
    // 释放图片的数据源
    if (source) CFRelease(source);
    
    // 展示一定要在主线程,否则会卡顿
    weak(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        strong(self);
        self.image = [UIImage animatedImageWithImages:imageArray duration:allTime];
    });
}
#pragma mark 动态添加属性
// 图片宽度
- (CGFloat)jj_imageWidth
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setJj_imageWidth:(CGFloat)jj_imageWidth
{
    objc_setAssociatedObject(self, @selector(jj_imageWidth), @(jj_imageWidth), OBJC_ASSOCIATION_ASSIGN);
}
// 图片高度
- (CGFloat)jj_imageHeight
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
- (void)setJj_imageHeight:(CGFloat)jj_imageHeight
{
     objc_setAssociatedObject(self, @selector(jj_imageHeight), @(jj_imageHeight), OBJC_ASSOCIATION_ASSIGN);
}
@end
