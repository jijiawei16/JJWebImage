//
//  JJWebImageManager.m
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJWebImageManager.h"
#import "UIImageView+JJCache.h"

@implementation JJWebImageManager
static float imageCacheSize; // 计算缓存大小
static id _instance; // 单例

#pragma mark 第一次使用时创建,单例模式
+ (void)initialize{
    [JJWebImageManager manager];
    [[NSNotificationCenter defaultCenter] addObserver:[JJWebImageManager manager] selector:@selector(jj_cleanImageLocalCache)name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.清空缓存
}
+ (instancetype)manager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
+ (instancetype)alloc{
    
    if (_instance) {
        NSException *test = [NSException exceptionWithName:@"JJWebImageManager" reason:@"JJWebImageManager是一个单例,请使用manager来创建它" userInfo:nil];
        [test raise];
    }
    return [super alloc];
}
- (id)copy{
    return self;
}
- (id)mutableCopy{
    return self;
}
#pragma mark 懒加载
- (NSCache *)imageCache{
    
    if (_imageCache == nil) {
        _imageCache = [NSCache new];
    }
    return _imageCache;
}

- (NSMutableDictionary *)imageUrlDic{
    
    if (_imageUrlDic == nil) {
        _imageUrlDic = [NSMutableDictionary dictionary];
    }
    return _imageUrlDic;
}
#pragma mark 方法实现
- (float)jj_getImageLocalCache{
    
    imageCacheSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取图片缓存路径,拿到缓存数据数组
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileList ;
    fileList =[fileManager contentsOfDirectoryAtPath:document error:NULL];
    
    for (NSString *file in fileList) {
        
        // 拿到每张图片的大小
        NSString *path =[document stringByAppendingPathComponent:file];
        NSData *data = [NSData dataWithContentsOfFile:path];
        // 累加图片大小
        imageCacheSize += (int)data.length;
    }
    // 计算图片缓存总大小
    imageCacheSize = imageCacheSize/1024/1024;
    
    return imageCacheSize;
}

- (void)jj_cleanImageLocalCache{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取图片缓存路径,拿到缓存数据数组
    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgFile = [document stringByAppendingPathComponent:@"jj_webImageCache"];
    NSArray *fileList ;
    fileList =[fileManager contentsOfDirectoryAtPath:imgFile error:NULL];
    
    for (NSString *file in fileList) {
        
        // 清除缓存图片
        NSString *path =[imgFile stringByAppendingPathComponent:file];
        BOOL blDele= [fileManager removeItemAtPath:path error:nil];
        if (blDele) {
            NSLog(@"清除图片本地缓存成功");
        }else {
            NSLog(@"清除图片本地缓存失败");
        }
    }
    // 初始化图片执行下载操作字典
    self.imageUrlDic = [NSMutableDictionary dictionary];
    self.imageCache = [NSCache new];
}
@end
