//
//  JWCBannerDataProtocol.h
//  BannerView
//
//  Created by JiWuChao on 2017/7/31.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JWCBannerDataProtocol <NSObject>

@property (nonatomic,copy,readonly) NSString *imageUrl;

@property (nonatomic,copy,readonly) NSString *title;

@end
