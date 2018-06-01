//
//  JJWebImageManager.h
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JJWebImageManager;

@interface JJWebImageManager : NSObject <NSCacheDelegate>

/*
 * 图片缓存字典
 */
@property (nonatomic , strong) NSCache *imageCache;

/*
 * 图片url缓存字典,用来判断该图片是否加入过下载操作
 */
@property (nonatomic , strong) NSMutableDictionary *imageUrlDic;

/**
 创建图片管理单例
 */
+ (instancetype)manager;

/**
 获取到图片当前本地缓存大小
 */
- (float)jj_getImageLocalCache;

/**
 清理本地图片缓存
 */
- (void)jj_cleanImageLocalCache;
@end
