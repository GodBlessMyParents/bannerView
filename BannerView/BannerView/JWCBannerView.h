//
//  JWCBannerView.h
//  BannerView
//
//  Created by JiWuChao on 2017/8/4.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWCBannerDataProtocol.h"

@interface JWCBannerView : UIView


@property (nonatomic, copy) NSArray <id <JWCBannerDataProtocol>> * bannerData;

@end
