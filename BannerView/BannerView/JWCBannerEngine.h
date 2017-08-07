//
//  JWCBannerEngine.h
//  BannerView
//
//  Created by JiWuChao on 2017/7/31.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWCBannerDataProtocol.h"

@class JWCBannerEngine;

@protocol JWCBannerEngineDelegate <NSObject>

- (void)bannerEngine:(JWCBannerEngine *)banner didSelectedWithIndex:(NSInteger)index withSelectedBannerInfo:(id <JWCBannerDataProtocol>)bannerInfo;

- (void)bannerEngine:(JWCBannerEngine *)banner currentIndex:(NSInteger)index currentModel:(id <JWCBannerDataProtocol>)data;

@end

@interface JWCBannerEngine : UICollectionView

- (instancetype)initAdsBannerWith:(UICollectionViewLayout *)layout;

@property (nonatomic, weak) id <JWCBannerEngineDelegate> bannerEngineDelegate;

- (void)updateBannerWithData:(NSArray <id <JWCBannerDataProtocol>> *)datas;

@end
