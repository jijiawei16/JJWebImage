//
//  UIImageView+JJCache.m
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "UIImageView+JJCache.h"
#import "JJWebImageManager.h"
#import "UIImageView+JJGif.h"
#import <objc/runtime.h>

#define weak(obj)   __weak typeof(obj) weakSelf = obj
#define strong(obj) __strong typeof(weakSelf) obj = weakSelf

@interface UIImageView() <JJWebImageDownloadDelegate,NSURLSessionDelegate>
// 获取图片下载进度block回调
@property (nonatomic , copy) JJWebImageDownloadProgress JJ_WebImageDownloadProgress;
// 下载图片de请求
@property (nonatomic , strong) NSURLSessionDownloadTask *JJ_WebImageDownloadTask;
@end
@implementation UIImageView (JJCache)

#pragma mark 设置图片,获取图片下载进度，设置占位图
- (void)jj_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder progress:(JJWebImageDownloadProgress)jj_webImageDownloadProgress
{
    // 设置图片下载回调(下面代码必须加，否则会出现问题)
    if (jj_webImageDownloadProgress) {
        // 动态关联block
        objc_setAssociatedObject(self, @selector(JJ_WebImageDownloadProgress), jj_webImageDownloadProgress, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    self.JJ_WebImageDownloadProgress = [jj_webImageDownloadProgress copy];
    [self jj_setImageWithUrl:url placeholder:placeholder];
}
#pragma mark 设置图片,并设置占位图
- (void)jj_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder
{
    self.image = placeholder;
    [self jj_setImageWithUrl:url];
}
#pragma mark 设置图片,获取图片下载进度，不设置占位图
- (void)jj_setImageWithUrl:(NSURL *)url progress:(JJWebImageDownloadProgress)jj_webImageDownloadProgress
{
    // 设置图片下载回调(下面代码必须加，否则会出现提前释放的问题)
    if (jj_webImageDownloadProgress) {
        // 动态关联block
        objc_setAssociatedObject(self, @selector(JJ_WebImageDownloadProgress), jj_webImageDownloadProgress, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    // 设置图片下载回调
    self.JJ_WebImageDownloadProgress = [jj_webImageDownloadProgress copy];
    [self jj_setImageWithUrl:url];
}
#pragma mark 设置图片,不需要设置占位图
- (void)jj_setImageWithUrl:(NSURL *)url
{
    [self.JJ_WebImageDownloadTask cancel];
    NSString *urlStr = url.absoluteString;
    if (!urlStr) return;
    
    // 异步操作，提高性能
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        JJWebImageManager *manager = [JJWebImageManager manager];
        // 判断内存是否有缓存
        if (![manager.imageCache objectForKey:urlStr]) {

            // 获取沙盒缓存的根路径
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // 获取图片缓存的根路径
            NSString *imgFile = [document stringByAppendingPathComponent:@"jj_webImageCache"];
            // 获取当前图片的缓存路径
            NSString *filePath = [imgFile stringByAppendingPathComponent:[self getNewStr:[NSString stringWithFormat:@"%@",url]]];
            // 判断磁盘是否有缓存
            BOOL is_haveFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            if (!is_haveFile) {
                NSLog(@"创建了下载任务");
                // 如果磁盘没有缓存，从网络下载，然后再加载本地缓存图片
                [self downloadWithUrl:url];
            }else{
                NSLog(@"加载本地图片");
                // 如果本地有缓存，直接加载本地图片
                [self locationImageWithFilePath:filePath urlStr:urlStr];
            }
        }else{
            
            // 内存中有缓存，直接加载内存缓存图片
            UIImage *image = [manager.imageCache objectForKey:urlStr];
            if (image) {
                // 强制对图片进行解码
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
                [image drawInRect:self.bounds];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                // 展示一定要在主线程,否则会卡顿
                weak(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    strong(self);
                    self.image = image;
                });
            }
        }
    });
}
#pragma mark 网络下载会先下载图片，然后在本地存储，最后加载本地图片
- (void)locationImageWithFilePath:(NSString *)filePath
                           urlStr:(NSString *)urlStr{
    
    JJWebImageManager *manager = [JJWebImageManager manager];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    // 判断是否是本地gif
    if ([self is_gif:url]) {

        // 加载本地gif图片
        [self jj_getGIFWithUrl:url];
    }else{
        NSData *imgData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:imgData];

        if (image) [manager.imageCache setObject:image forKey:urlStr];
        // 展示一定要在主线程,否则会卡顿
        weak(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            strong(self);
            self.image = image;
        });
    }
}
#pragma mark 创建下载任务
- (void)downloadWithUrl:(NSURL *)url{
    
    // 创建图片网络请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    // 创建下载图片请求 dataTask
    self.JJ_WebImageDownloadTask = [session downloadTaskWithRequest:request];
    // 发送请求
    [self.JJ_WebImageDownloadTask resume];
}
#pragma mark 图片下载网络请求代理方法
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    // 获取到图片文件临时保存的路径
    NSString *locationString = [location path];
    // 设置沙盒缓存根路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // 设置图片缓存保存的根路径
    NSString *imgFile = [document stringByAppendingPathComponent:@"jj_webImageCache"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // 判断该路径是否为有效文件
    BOOL existed = [fileManager fileExistsAtPath:imgFile isDirectory:&isDir];
    if (!existed) {
        // 在该路径创建文件
        [[NSFileManager defaultManager] createDirectoryAtPath:imgFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 设置该图片的缓存路径
    NSString *filePath = [imgFile stringByAppendingPathComponent:[self getNewStr:[NSString stringWithFormat:@"%@",downloadTask.response.URL]]];
    // 将下载的图片文件转移到自定义的位置
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:locationString toPath:filePath error:&error];
    
    NSString *urlStr = downloadTask.response.URL.absoluteString;
    // 更新UI（加载本地保存的图片）
    [self locationImageWithFilePath:filePath urlStr:urlStr];
}
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    // 获取到图片的下载进度,可以通过block或代理进行传值
    if (self.JJ_WebImageDownloadProgress) {
        self.JJ_WebImageDownloadProgress((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite * 100);
    }
    if ([self.JJ_imageDelegate respondsToSelector:@selector(jj_getImageView:downloadProgress:)]) {
        [self.JJ_imageDelegate jj_getImageView:self downloadProgress:(CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite * 100];
    }
}
#pragma mark 加载本地gif图片
- (UIImage *)jj_getLocationGIFWithContentFile:(NSString *)path
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
    return [UIImage animatedImageWithImages:imageArray duration:allTime];
}
#pragma mark 动态绑定属性(代理属性,block属性,图片下载请求属性)
// 代理属性
- (id<JJWebImageDownloadDelegate>)JJ_imageDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJJ_imageDelegate:(id<JJWebImageDownloadDelegate>)JJ_imageDelegate
{
    objc_setAssociatedObject(self, @selector(JJ_imageDelegate), JJ_imageDelegate, OBJC_ASSOCIATION_ASSIGN);
}
// block属性
- (JJWebImageDownloadProgress)JJ_WebImageDownloadProgress
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJJ_WebImageDownloadProgress:(JJWebImageDownloadProgress)JJ_WebImageDownloadProgress
{
    objc_setAssociatedObject(self, @selector(JJ_WebImageDownloadProgress), JJ_WebImageDownloadProgress, OBJC_ASSOCIATION_COPY);
}
// 图片下载请求属性
- (NSURLSessionDownloadTask *)JJ_WebImageDownloadTask
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setJJ_WebImageDownloadTask:(NSURLSessionDownloadTask *)JJ_WebImageDownloadTask
{
    objc_setAssociatedObject(self, @selector(JJ_WebImageDownloadTask), JJ_WebImageDownloadTask, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark 对url进行处理,以防图片缓存重名
- (NSString *)getNewStr:(NSString *)str {
    
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)str,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8));
    return outputStr;
}
@end
