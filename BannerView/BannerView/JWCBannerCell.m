//
//  LZAdsBannerCell.m
//  BannerView
//
//  Created by JiWuChao on 2017/8/1.
//  Copyright © 2017年 JiWuChao. All rights reserved.
//

#import "JWCBannerCell.h"

#import "Masonry.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface JWCBannerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation JWCBannerCell


- (void)setData:(id<JWCBannerDataProtocol>)data {
    _data = data;
    if ([_data conformsToProtocol:@protocol(JWCBannerDataProtocol) ]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl]  placeholderImage:[UIImage imageNamed:@"noimage"] options:SDWebImageRetryFailed];
    }
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _imageView;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:14];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        [self addSubview:_titleLbl];
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.equalTo(self.imageView);
            make.trailing.equalTo(self.imageView.mas_trailing).offset(-100);
            make.height.mas_equalTo(35);
        }];
    }
    return _titleLbl;
}


@end
