//
//  UIImageView+JJGif.h
//  封装一些小控件
//
//  Created by 16 on 2018/5/29.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JJGif)

/*
 * image的宽度(图片原来的宽度)
 */
@property (nonatomic , assign) CGFloat jj_imageWidth;

/*
 * image的高度(图片原来的高度)
 */
@property (nonatomic , assign) CGFloat jj_imageHeight;

/*
 * 判断是否是gif图片
 */
- (BOOL)is_gif:(NSURL *)url;

/*
 * 加载gif图片
 */
- (void)jj_getGIFWithUrl:(NSURL *)url;

/*
 * 加载本地gif图片
 */
- (void)jj_getLocationGIFWithContentFile:(NSString *)path;
@end
