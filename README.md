很详细的介绍了图片加载与缓存的详细流程:
==
1.可以自动识别gif和普通图片,直接加载gif或普通图片
--
    `
    [imageView jj_setImageWithUrl:@"网络图片地址"];
        `
2.本地缓存,再一次加载会直接加载本地缓存图片
--
3.可以加载本地gif图来作为placehoulder
--
    `
    [imageView jj_setImageWithUrl:@"网络图片地址" placeholder:[UIImage jj_getLocationGIFWithContentFile:@"本地gif图片地址"]];
        `
