//
//  LearnOneViewCell.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "LearnOneViewCell.h"

@implementation LearnOneViewCell

- (void)awakeFromNib {
    // Initialization code
}


#pragma mark - 填充数据
- (void)updateWithModel:(LearnViewShowModel *)model {
    NSArray *imageArr = [model.img componentsSeparatedByString:@","];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:imageArr.firstObject] placeholderImage:[UIImage imageNamed:@"placepic.png"]];
    self.titleLabel.text = model.title;
    self.typeLabel.text = model.studyType;
    self.typeLabel.layer.masksToBounds=YES;
    self.typeLabel.layer.cornerRadius=2.5f;
    
    [self.zanButton setTitle:model.GoodCount forState:UIControlStateNormal];
    [self.caiButton setTitle:model.BadCount forState:UIControlStateNormal];
    [self.commentButton setTitle:model.CommentCount forState:UIControlStateNormal];
    
    self.contentLabel.text = model.summary;
    self.isKanNumber.text = model.readCount;
    
    CGRect rect = [model.studyType boundingRectWithSize:CGSizeMake(SIZE_MAX, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
    self.cellTypeLabelWithAutoLayout.constant = rect.size.width+10;
    
    CGFloat titleHight = [self textHeightFromTextString:model.title width:Screen_width-(12+rect.size.width+10+10) fontSize:16];
    if (titleHight > 25.f) {
        self.titleLabel.numberOfLines = 0;
    }else {
        self.titleLabel.numberOfLines = 1;
    }
}

////根据字符串的实际内容的多少,在固定的宽度和字体的大小,动态的计算出实际的高度
- (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    // 设置行间距
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size],NSParagraphStyleAttributeName:paragraphStyle1};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    //返回计算出的行高
    return rect.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
