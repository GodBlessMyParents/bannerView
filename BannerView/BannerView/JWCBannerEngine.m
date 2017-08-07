//
//  JWCBannerEngine.m
//
//  Created by JiWuChao on 2017/7/31.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import "JWCBannerEngine.h"

#import "Masonry.h"

#import "JWCBannerCell.h"


@interface JWCBannerEngine ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, copy) NSArray <id<JWCBannerDataProtocol>> *customData;

@property (nonatomic, copy) NSArray <id<JWCBannerDataProtocol>> *originalData;

@property (nonatomic ,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isOnlyOne;

@end


@implementation JWCBannerEngine


#pragma mark - Public

- (instancetype)initAdsBannerWith:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    if (self) {
        [self initViews];
    }
    return self;
}


- (void)updateBannerWithData:(NSArray<id<JWCBannerDataProtocol>> *)datas {
    _originalData = datas;
    [self configWithData:_originalData];
}


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


- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex && !self.isOnlyOne) {
        return;
    }
    _currentIndex = currentIndex;
    id <JWCBannerDataProtocol> data = nil;
    if (_currentIndex >= 0 && _currentIndex < _originalData.count) {
        data = _originalData[_currentIndex];
    }
    if ([_bannerEngineDelegate respondsToSelector:@selector(bannerEngine:currentIndex:currentModel:)]) {
        [_bannerEngineDelegate bannerEngine:self currentIndex:_currentIndex currentModel:data];
    }
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.customData.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0  && indexPath.row < _customData.count) {
        JWCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JWCBannerCell class]) forIndexPath:indexPath];
        cell.data = self.customData[indexPath.row];
        return cell;
    }
    return [[UICollectionViewCell alloc]init];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JWCBannerCell *cell = (JWCBannerCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([_bannerEngineDelegate respondsToSelector:@selector(bannerEngine:didSelectedWithIndex:withSelectedBannerInfo:)]) {
        [_bannerEngineDelegate bannerEngine:self didSelectedWithIndex:indexPath.item withSelectedBannerInfo:cell.data];
    }
}

#pragma mark - UIScrollViewDelegate

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

// 将要开始拖拽 停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
// 将要停止拖拽 开始定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_originalData.count > 1) {
        [self startTimer];
    }
}

// 停止拖动  
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkPageIndx];
}

// 动画停止 当 setContentOffset/scrollRectVisible:animated: 动画完成时会调用 没有动画不会调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self checkPageIndx];
}

// 停止滚动 计算当前的index
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

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page >= _customData.count) {
        page = _customData.count - 1;
    } else if (page < 0) {
        page = 0;
    }
    [self setContentOffset:CGPointMake(page * self.bounds.size.width, 0) animated:animated];
}

- (void)startScrollAutomtically { // 每次加 self.bounds.size.width 宽度
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.bounds.size.width, self.contentOffset.y) animated:YES];
}


#pragma mark - timer

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    } else {}
}

- (void)startTimer {
    _timer = [NSTimer timerWithTimeInterval:2
                                     target:self
                                   selector:@selector(startScrollAutomtically)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer
                                 forMode:NSRunLoopCommonModes];
}

#pragma mark - setViews

- (void)initViews {
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[JWCBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([JWCBannerCell class])];
    self.backgroundColor = [UIColor whiteColor];
    self.isOnlyOne = NO;
}


- (void)dealloc {
    [self stopTimer];
}




@end
