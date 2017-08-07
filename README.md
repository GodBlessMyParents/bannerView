
## collectionView 无限轮播设计思路


原来用scrollview实现过无限轮播，每张轮播图是UIImageView 
，有页码，有标题，用scrollView实现起来比较简单。但是最近遇到一个需求
。每个轮播图上有好几个头像和按钮，用目前项目中用scrollView实现的轮播
图实现不了，或者说改动比较大。于是就想着用collectionView实现。当时的
初步构想就是每张轮播图就是一个自定义的cell ，这样就比较简单了。
在没开始之前先在在网上找了一下，好多demo实现的方式都是一样的，就是把dataSource设为一个很大的数字，创建n多个cell，用来达到无限。。。按道理，先不说性能如何，就是设为比较大的数字，在理论上该数字也是有限的！并不是无限轮播~~~

我的大致设计思路如下：

```
1，定时器。用于在固定的间隔滚动一页
2，collectionView，自定义一个cell用于轮播展示
3，对collectionView的数据源A进行处理。新建一个数组B，把A数组的最后一个添加到B数组的第一个，把A数组的第一个添加到B数组的最后一个。这样B数组中就比源数组A多了两个数据。在(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section 中返回的是数组B的长度
4， 在scrollview的相关代理方法中处理相应人为拖动操作和滚动
```


下面结合代码来说每步的具体实现。

1> 每隔固定的时间调用此方法实现滚动

```
- (void)startScrollAutomtically { // 每次加 self.bounds.size.width 宽度
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.bounds.size.width, self.contentOffset.y) animated:YES];
}
```


2> 对数据源进行处理  如果原始数据源的长度大于一个则启动定时器，反之不启动定时器。如果原始数据源的长度大于一个则需要处理数据源，即上面3所说的。另外刷新完数据源则默认滚动到第一页

```
- (void)configWithData:(NSArray<id<JWCBannerDataProtocol>> *)datas {
    if (_originalData.count > 1) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:_originalData];
        [tempArr insertObject:[_originalData lastObject] atIndex:0];
        [tempArr addObject:[_originalData firstObject]];
        self.customData = tempArr.copy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToPage:1 animated:YES];
        });
        [self startTimer];
        self.isOnlyOne = NO;
    } else {
        self.customData = _originalData.copy;
        [self stopTimer];
        self.isOnlyOne = YES;
        self.currentIndex = 0;
    }
}



```
3> scrollView的几个代理方法


```
// 将要开始拖拽 停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
// 将要停止拖拽 开始定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_originalData.count > 1) { //如果数据源大于1 才启动定时器
        [self startTimer];
    }
}
// 停止拖动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkPageIndx];
}
// 动画停止
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkPageIndx];
}

```

// 此方法是人为拖动完成需要做的处理

```
- (void)checkPageIndx {
    //当滚动到最后一张图片时，继续滚向后动跳到page 1
    if (self.contentOffset.x >= (self.customData.count - 1) * self.bounds.size.width) {
        [self scrollToPage:1 animated:NO];
    }
    //当滚动到第一张图片时，继续向前滚动跳到倒数第二
    if (self.contentOffset.x < 0) {
        [self scrollToPage:self.customData.count - 2 animated:NO];
    }
}
```

// 停止滚动 计算当前的index   此方法是无论人为还是自动改变scrollview的 offset 都会调用此方法 所以在此方法中计算当前的index 这个index可用于显示页码


```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.frame.size.width;
    NSInteger index = (scrollView.contentOffset.x + width * 0.5 ) / width;
    if (index == 0) {
        index = _originalData.count - 1;
    } else if (index >= _customData.count - 1) {
        index = 0;
    } else {
        index = index - 1;
    }
    self.currentIndex = index;
}
```


以上只是写了大致的思路，具体的细节实现看代码