//
//  PkSummaryTableViewCell.m
//  EnergyCycles
//
//  Created by 王斌 on 16/8/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "PkSummaryTableViewCell.h"

@implementation PkSummaryTableViewCell

- (void)getDataWithModel:(PkSummaryModel *)model {
    
    if (model == nil) {
        self.reportNum.text = @"--";
        self.allDayNum.text = @"--";
        self.praiseCount.text = @"--";
        self.praiseRanking.text = @"--";
    } else {
        NSMutableAttributedString *reportText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次",model.ReportNum]];
        [reportText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(reportText.length - 1, 1)];
        self.reportNum.attributedText = reportText;
        
        NSMutableAttributedString *allDayText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",model.AllDayNum]];
        [allDayText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(allDayText.length - 1, 1)];
        self.allDayNum.attributedText = allDayText;
        
        NSMutableAttributedString *praiseCountText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@个",model.Goods]];
        [praiseCountText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(praiseCountText.length - 1, 1)];
        self.praiseCount.attributedText = praiseCountText;
        
        NSMutableAttributedString *praiseRankingText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@名",[model.GoodsRanking isEqualToString:@"0"] ? @"--" : model.GoodsRanking]];
        [praiseRankingText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(praiseRankingText.length - 1, 1)];
        self.praiseRanking.attributedText = praiseRankingText;
    }
    
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
