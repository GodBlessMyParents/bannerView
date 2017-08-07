//
//  BannerData.h
//  BannerView
//
//  Created by JiWuChao on 2017/8/4.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWCBannerDataProtocol.h"

@interface BannerData : NSObject <JWCBannerDataProtocol>

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *title;

@end
