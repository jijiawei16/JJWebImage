//
//  UIImage+JJLocationGif.h
//  封装一些小控件
//
//  Created by 16 on 2018/5/30.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JJLocationGif)

/*
 * 加载本地gif图片
 */
+ (UIImage *)jj_getLocationGIFWithContentFile:(NSString *)path;
@end
