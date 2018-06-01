//
//  UIImageView+JJCache.h
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理方法:获取图片下载进度
@protocol JJWebImageDownloadDelegate <NSObject>

- (void)jj_getImageView:(UIImageView *)imageView downloadProgress:(CGFloat)progress;
@end

// block:获取图片下载回调
typedef void (^JJWebImageDownloadProgress)(CGFloat value);
@interface UIImageView (JJCache) <JJWebImageDownloadDelegate>

/*
 * 代理
 */
@property (nonatomic , weak) id<JJWebImageDownloadDelegate> JJ_imageDelegate;

/*
 * 设置图片,不需要设置占位图
 */
- (void)jj_setImageWithUrl:(NSURL *)url;

/*
 * 设置图片,并设置占位图
 */
- (void)jj_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder;

/*
 * 设置图片,获取图片下载进度，不设置占位图
 */
- (void)jj_setImageWithUrl:(NSURL *)url progress:(JJWebImageDownloadProgress)jj_webImageDownloadProgress;

/*
 * 设置图片,获取图片下载进度，设置占位图
 */
- (void)jj_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder progress:(JJWebImageDownloadProgress)jj_webImageDownloadProgress;

/*
 * 加载动态本地gif图,主要设置动态的placehoulder图片
 */
- (UIImage *)jj_getLocationGIFWithContentFile:(NSString *)path;
@end
