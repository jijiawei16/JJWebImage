//
//  ViewController.m
//  图片加载测试
//
//  Created by 16 on 2018/6/1.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JJWebImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 300, 150)];
    
    // 直接加载图片,不需要placehould图片,不需要获取图片下载进度
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"]];
    
    // 加载图片并获取图片下载进度,但不需要placehould图片
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] progress:^(CGFloat value) {
        NSLog(@"%f",value);
    }];
    
    
    // 加载图片并获取图片下载进度,设置placrhould普通图片
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage imageNamed:@"占位图片"] progress:^(CGFloat value) {
        NSLog(@"%f",value);
    }];
    
    
    // 加载图片并获取图片下载进度,设置placrhould本地图片(可以使本地gif图片)
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage jj_getLocationGIFWithContentFile:[[NSBundle mainBundle] pathForResource:@"本地gif图" ofType:nil]] progress:^(CGFloat value) {
        NSLog(@"%f",value);
    }];
    
    
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-5/201851120571622260.gif"] placeholder:[UIImage jj_getLocationGIFWithContentFile:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]]];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
