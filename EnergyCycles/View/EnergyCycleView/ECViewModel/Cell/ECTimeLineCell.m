//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "ECTimeLineCell.h"

#import "ECTimeLineModel.h"
#import "UIView+SDAutoLayout.h"

#import "SDTimeLineCellCommentView.h"

#import "SDWeiXinPhotoContainerView.h"

#import "SDTimeLineCellOperationMenu.h"

#import "SDTimeLineCellBottomView.h"

#import "LEETheme.h"

#import "UIImageView+WebCache.h"

const CGFloat contentLabelFontSize2 = 14;
CGFloat maxContentLabelHeight2 = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@interface ECTimeLineCell ()<SDTimeLineCellCommentViewDelegate>

@end

@implementation ECTimeLineCell

{
    UIImageView *_iconView;
    UIButton *iconButton;
    UILabel *_nameLable;
    UIButton *_deleteButton;
    UIImageView *_locaIcon;
    UILabel *_location;
    UILabel *_time;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UIButton *_moreButton;
    UIButton *_operationButton;
    SDTimeLineCellCommentView *_commentView;
    BOOL _shouldOpenContentLabel;
    SDTimeLineCellOperationMenu *_operationMenu;
    SDTimeLineCellBottomView * _bottomView;
    UIView * _marginView;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        //设置主题
        
        [self configTheme];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    _shouldOpenContentLabel = NO;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7];
    
    _iconView = [UIImageView new];
  
    iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconButton addTarget:self action:@selector(tapIcon) forControlEvents:UIControlEventTouchUpInside];
    
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(74 / 255.0) green:(74 / 255.0) blue:(74 / 255.0) alpha:1.0];
    
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"trash-icon"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    
    _locaIcon = [UIImageView new];
    _locaIcon.image = [UIImage imageNamed:@"location_icon"];
    
    _location = [UILabel new];
    _location.font = [UIFont systemFontOfSize:14];
    _location.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    
    _time = [UILabel new];
    _time.font = [UIFont systemFontOfSize:12];
    _time.textColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize2];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight2 == 0) {
        maxContentLabelHeight2 = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [SDTimeLineCellCommentView new];
    _commentView.delegate = self;
    _commentView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    
    _operationMenu = [SDTimeLineCellOperationMenu new];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf];
        }
    }];
    
    _bottomView = [SDTimeLineCellBottomView new];
    _bottomView.model = self.model;
    _bottomView.SDTimeLineCellBottomSelectedBlock = ^(NSInteger type){
        switch (type) {
            case 0:
                weakSelf.type = ECTimeLineCellActionTypeShare;
                break;
            case 1:
                weakSelf.type = ECTimeLineCellActionTypeComment;
                break;
            case 2:
                weakSelf.type = ECTimeLineCellActionTypeLike;
                break;
                
            default:
                break;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(didActionInCell:actionType:atIndexPath:)]) {
            [weakSelf.delegate didActionInCell:weakSelf actionType:weakSelf.type atIndexPath:weakSelf.indexPath];
        }
    };
    
    _marginView = [UIView new];
    _marginView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    
    
    NSArray *views = @[line, _iconView,iconButton, _nameLable,_deleteButton, _time, _contentLabel, _moreButton, _picContainerView, _operationButton, _operationMenu, _commentView,_bottomView,_marginView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    line.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topEqualToView(contentView)
    .heightIs(1);
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(line, margin + 5)
    .widthIs(50)
    .heightIs(50);
    _iconView.sd_cornerRadiusFromHeightRatio = [NSNumber numberWithFloat:0.5];
    
    iconButton.sd_layout
    .leftEqualToView(_iconView)
    .topEqualToView(_iconView)
    .widthRatioToView(_iconView,1)
    .heightRatioToView(_iconView,1);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _deleteButton.sd_layout
    .rightSpaceToView(contentView,10)
    .topSpaceToView(contentView,10)
    .widthIs(20)
    .heightIs(20);
    
    _locaIcon.sd_layout
    .leftSpaceToView(_iconView,margin)
    .topSpaceToView(_nameLable,margin + 5)
    .widthIs(14)
    .heightIs(17);
    
    _location.sd_layout
    .leftSpaceToView(_locaIcon,5)
    .topSpaceToView(_nameLable,5);
    
    _time.sd_layout
    .leftSpaceToView(_iconView, 10)
    .heightIs(20)
    .topSpaceToView(_nameLable,margin); 
    
    [_time setSingleLineAutoResizeWithMaxWidth:100];
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_picContainerView, margin); // 已经在内部实现高度自适应所以不需要再设置高度
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
    _bottomView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_commentView,margin)
    .heightIs(40);
    
    _marginView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_bottomView,0)
    .heightIs(15);
    
}


- (void)tapIcon {
    
    if ([self.delegate respondsToSelector:@selector(didClickOtherUser:userId:userName:)]) {
        [self.delegate didClickOtherUser:self userId:self.model.UserID userName:self.model.name];
    }
    
}

- (void)deleteAction {
    
    if ([self.delegate respondsToSelector:@selector(didDelete:atIndexPath:)]) {
        [self.delegate didDelete:self.model atIndexPath:self.indexPath];
    }
}

- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
    
    _contentLabel.lee_theme
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor grayColor]);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(ECTimeLineModel *)model
{
    _model = model;
    
    if ([model.UserID isEqualToString:[NSString stringWithFormat:@"%@",User_ID]]) {
        _deleteButton.hidden = NO;
    }else {
        _deleteButton.hidden = YES;
    }
    
    _commentView.frame = CGRectZero;
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    _shouldOpenContentLabel = NO;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconName] placeholderImage:EC_AVATAR_PLACEHOLDER];
    _nameLable.text = model.name;
    _location.text = model.location;
    _time.text = model.time;
    
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nameLable sizeToFit];
    _contentLabel.text = model.msgContent;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight2);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }else {
        _picContainerView.fixedHeight = @0;
        _picContainerView.picPathStringsArray = model.picNamesArray;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.picNamesArray.count && !model.commentItemsArray.count && !model.likeItemsArray.count) {
        _commentView.fixedWidth = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWidth的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        _commentView.sd_layout.topSpaceToView(_contentLabel,0);
        _bottomView.sd_layout.topSpaceToView(_picContainerView, 10);

        
    }
    else if (model.commentItemsArray.count == 0 && model.likeItemsArray.count == 0) {
        _commentView.fixedWidth = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWidth的控件将不再在自动布局过程中调整宽度）
        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        _commentView.sd_layout.topSpaceToView(_picContainerView, 0);
        _bottomView.sd_layout.topSpaceToView(_picContainerView, 10);
        bottomView = _picContainerView;
    }
    else {
        _commentView.fixedHeight = nil; // 取消固定宽度约束
        _commentView.fixedWidth = nil; // 取消固定高度约束
        _commentView.sd_layout.topSpaceToView(_picContainerView, 10);
        _bottomView.sd_layout.topSpaceToView(_commentView, 10);
        bottomView = _commentView;
    }
    
    _bottomView.model = model;
    
    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:10];
    
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark SDCommentViewCellDelegate

- (void)didClickLink:(NSString *)linkId linkName:(NSString *)linkName {
    if ([self.delegate respondsToSelector:@selector(didClickOtherUser:userId:userName:)]) {
        [self.delegate didClickOtherUser:self userId:linkId userName:linkName];
    }
}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

@end

