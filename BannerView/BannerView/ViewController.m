//
//  ViewController.m
//  BannerView
//
//  Created by JiWuChao on 2017/7/28.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "JWCBannerView.h"

#import "BannerData.h"

#import "Masonry.h"

@interface ViewController ()


@property (nonatomic, strong) JWCBannerView *banner;

@property (nonatomic, copy) NSArray *dataS;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self banner];
    [self createData];
}


- (void)createData {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 3; i ++) {
        BannerData *data = [[BannerData alloc] init];
        if (i % 2 == 0) {
            data.imageUrl = @"http://img2.plures.net/7eaa/235d/db80/6164/8ac5/9656/2597/45a8.jpg";
        } else {
            data.imageUrl = @"http://img2.plures.net/7eaa/235d/db80/6164/8ac5/9656/2597/45a8.jpg";
        }
        data.title = [NSString stringWithFormat:@"第%ld张",i + 1];
        [arr addObject:data];
    }
    self.dataS = arr.copy;
    self.banner.bannerData = self.dataS.copy;
}


- (JWCBannerView *)banner {
    if (!_banner) {
        _banner = [[JWCBannerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_banner];
        [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.leading.trailing.equalTo(self.view);
            make.height.mas_equalTo(150);
        }];
    }
    return _banner;
}



@end
