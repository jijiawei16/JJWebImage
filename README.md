○具有什么特点?
--
1.图片本地缓存,下次使用自动加载</br>
2.直接展示加载的网络/本地gif图片</br>
3.实时获取到加载的网络图片的下载进度</br>
4.一键获取图片本地缓存,一键清空图片本地缓存</br>
5.一键获取网络图片的尺寸</br>
6.文件简单,拖进项目即可使用</br>

○怎么使用?
--
1.直接加载图片</br>
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"]];
`</br>
</br>
2.加载图片并获取图片下载进度</br>
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`</br>
</br>
3.加载图片并获取图片下载进度,设置placrhould普通图片</br>
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage imageNamed:@"占位图片"] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`</br>
</br>
4.加载图片并获取图片下载进度,设置placrhould本地图片(可以使本地gif图片)</br>
`
[imageView jj_setImageWithUrl:[NSURL URLWithString:@"图片url"] placeholder:[UIImage jj_getLocationGIFWithContentFile:[[NSBundle mainBundle] pathForResource:@"本地gif图" ofType:nil]] progress:^(CGFloat value) {
NSLog(@"%f",value);
}];
`
        
        
        
        
        
        
        
        
