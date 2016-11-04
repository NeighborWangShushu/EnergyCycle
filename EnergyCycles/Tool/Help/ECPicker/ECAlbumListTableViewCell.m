//
//  ECAlbumListTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECAlbumListTableViewCell.h"

@interface ECAlbumListTableViewCell ()

@property (nonatomic, strong) UIImageView *albumImageView;

@property (nonatomic, strong) UILabel *albumTitle;

@end

@implementation ECAlbumListTableViewCell

- (void)updateDataWithTitle:(NSString *)title Count:(NSInteger)count{
    
    self.textLabel.text = [self transformAblumTitle:title];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld", count];
    
    CGSize itemSize = CGSizeMake(50.f, 50.f);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.f, 0.f, itemSize.width, itemSize.height);
    
    [self.imageView.image drawInRect:imageRect];
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.albumImageView.image = [UIImage imageNamed:@"AlbumNoAsset"];
    
}

- (UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.layer.cornerRadius = 5;
        _albumImageView.clipsToBounds = YES;
        [self.contentView addSubview:_albumImageView];
    }
    return _albumImageView;
}

- (void)setHeaderImage:(UIImage *)headerImage {
    self.albumImageView.image = headerImage;
}

- (NSString *)transformAblumTitle:(NSString *)title {
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
