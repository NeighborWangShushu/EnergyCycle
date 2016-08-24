//
//  DraftTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "DraftsTableViewCell.h"

@interface DraftsTableViewCell ()

@property (nonatomic, strong) DraftsModel *model;
@property (nonatomic, assign) NSIndexPath *indexPath;

@end

@implementation DraftsTableViewCell

- (void)getDraftsData:(DraftsModel *)model indexPath:(NSIndexPath *)indexPath{
    
    self.model = model;
    self.indexPath = indexPath;
    
    self.timeLabel.text = model.time;
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [file stringByAppendingPathComponent:model.imgLocalURL];
    filePath = [filePath stringByAppendingString:@".plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (array.count <= 0) {
        self.constraint.constant = 12;
        self.headImage.hidden = YES;
    } else {
        NSString *string = array[0];
        NSURL *url = [NSURL URLWithString:string];
        [self.headImage sd_setImageWithURL:url];
        self.headImage.hidden = NO;
    }
    
    self.contextLabel.text = model.context;
    
}

- (IBAction)retryAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Republish" object:self userInfo:@{@"model" : self.model, @"indexPath" : self.indexPath}];
    
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