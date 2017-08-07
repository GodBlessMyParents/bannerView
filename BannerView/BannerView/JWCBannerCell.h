//
//  JWCBannerCell.h
//  BannerView
//
//  Created by JiWuChao on 2017/8/1.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWCBannerDataProtocol.h"

@interface JWCBannerCell : UICollectionViewCell

@property (nonatomic, strong) id <JWCBannerDataProtocol> data;

@end
