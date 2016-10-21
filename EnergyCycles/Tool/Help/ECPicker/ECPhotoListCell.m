//
//  ECPhotoListCollectionViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPhotoListCell.h"

#define ECPhoto_selected @"ecphoto_selected"
#define ECPhoto_unselected @"ecphoto_unselected"

@interface ECPhotoListCell () {
    BOOL selected;
}

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation ECPhotoListCell

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
    [self.selectedButton setImage:[UIImage imageNamed:ECPhoto_unselected] forState:UIControlStateNormal];
    self.maskLayer.hidden = YES;
    selected = NO;
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.3].CGColor;
        [self.imageView.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        CGRect rect = CGRectMake((self.bounds.size.width / 3) * 2, 0, self.bounds.size.width / 3, self.bounds.size.width / 3);
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.frame = rect;
        [_selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectedButton];
    }
    return _selectedButton;
}

- (void)clickSelectedButton:(UIButton *)button {
    if (selected) {
        [button setImage:[UIImage imageNamed:ECPhoto_unselected] forState:UIControlStateNormal];
        self.maskLayer.hidden = YES;
        selected = NO;
    } else {
        [button setImage:[UIImage imageNamed:ECPhoto_selected] forState:UIControlStateNormal];
        self.maskLayer.hidden = NO;
        selected = YES;
    }
}

- (void)setSelected:(BOOL)selected {
    
}

@end
