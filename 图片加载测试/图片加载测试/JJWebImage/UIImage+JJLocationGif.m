//
//  UIImage+JJLocationGif.m
//  封装一些小控件
//
//  Created by 16 on 2018/5/30.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "UIImage+JJLocationGif.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (JJLocationGif)

+ (UIImage *)jj_getLocationGIFWithContentFile:(NSString *)path
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
    UIImage *image = [UIImage animatedImageWithImages:imageArray duration:allTime];
    return image;
}
@end
