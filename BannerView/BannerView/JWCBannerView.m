//
//  JWCBannerView.m
//  BannerView
//
//  Created by JiWuChao on 2017/8/4.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import "JWCBannerView.h"

#import "JWCBannerEngine.h"

#import "Masonry.h"

@interface JWCBannerView ()<JWCBannerEngineDelegate>

@property (nonatomic, strong) JWCBannerEngine *banenrEngine;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *bottomView;

@property (nonatomic, strong) UILabel *titleLbl;

@end


@implementation JWCBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViews];
    }
    return self;
}


- (void)setBannerData:(NSArray<id<JWCBannerDataProtocol>> *)bannerData {
    _bannerData = bannerData;
    [self.banenrEngine updateBannerWithData:_bannerData];
    if (bannerData.count > 1) {
        self.pageControl.numberOfPages = _bannerData.count;
        self.pageControl.hidden = NO;
    } else {
        self.pageControl.hidden = YES;
    }
}


- (void)bannerEngine:(JWCBannerEngine *)banner didSelectedWithIndex:(NSInteger)index withSelectedBannerInfo:(id<JWCBannerDataProtocol>)bannerInfo {
    NSLog(@"选中的是第%ld个",index);
}

- (void)bannerEngine:(JWCBannerEngine *)banner currentIndex:(NSInteger)index currentModel:(id<JWCBannerDataProtocol>)data {
    self.pageControl.currentPage = index;
    self.titleLbl.text = data.title;
    NSLog(@"---index>%ld",index);
}



#pragma mark - setViews

- (void)setViews {
    [self banenrEngine];
    [self bottomView];
    [self titleLbl];
    [self pageControl];
}

- (JWCBannerEngine *)banenrEngine {
    if (!_banenrEngine) {
        _banenrEngine = [[JWCBannerEngine alloc] initAdsBannerWith:[self layout]];
        _banenrEngine.bannerEngineDelegate = self;
        [self addSubview:_banenrEngine];
        [_banenrEngine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _banenrEngine;
}

- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    return flowLayout;
}


- (UIImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] init];
        _bottomView.image = [UIImage imageNamed:@"bg_home_slider_yinying"];
        [self.banenrEngine addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.bottom.equalTo(self);
            make.height.mas_equalTo(35);
        }];
    }
    return _bottomView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:14];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        [self.bottomView addSubview:_titleLbl];
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView);
            make.leading.equalTo(self.bottomView.mas_leading).offset(5);
            make.trailing.equalTo(self.bottomView.mas_trailing).offset(-100);
            make.height.mas_equalTo(35);
        }];
    }
    return _titleLbl;
}



- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self.bottomView addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.centerY.height.equalTo(self.bottomView);
            make.width.mas_equalTo(100);
        }];
    }
    return _pageControl;
}


@end
