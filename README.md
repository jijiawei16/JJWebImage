○具有什么特点?
--
1.图片本地缓存,下次使用
2.直接加载网络/本地gif图片
3.实时获取到网络图片的下载进度
4.一键获取图片缓存,一键清空图片缓存
5.一键获取网络图片尺寸
6.文件简单,拖进项目即可使用

○怎么使用?
--
直接加载图片
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"]];
`
加载图片并获取图片下载进度
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`
加载图片并获取图片下载进度,设置placrhould普通图片
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage imageNamed:@"占位图片"] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`
加载图片并获取图片下载进度,设置placrhould本地图片(可以使本地gif图片)
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage jj_getLocationGIFWithContentFile:[[NSBundle mainBundle] pathForResource:@"本地gif图" ofType:nil]] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`
        
        
        
        
        
        
        
        
