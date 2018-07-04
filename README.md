很详细的介绍了图片加载与缓存的详细流程:
==
1.可以自动识别gif和普通图片,直接加载gif或普通图片
--
    ```
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-5/201851120571622260.gif"]];
        ```
2.本地缓存,再一次加载会直接加载本地缓存图片
3.可以加载本地gif图来作为placehoulder
    ```
    [imageView jj_setImageWithUrl:[NSURL URLWithString:@"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-5/201851120571622260.gif"] placeholder:[UIImage jj_getLocationGIFWithContentFile:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]]];
        ```
