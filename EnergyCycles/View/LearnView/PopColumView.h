//
//  PopColumView.h
//  EnergyCycles
//
//  Created by Weijie Zhu on 16/6/17.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"

@protocol PopColumViewDelegate;

@interface PopColumView : UIView<RACollectionViewDelegateReorderableTripletLayout,RACollectionViewReorderableTripletLayoutDataSource>

- (instancetype)initWithData:(NSMutableArray*)data myColum:(NSMutableArray*)mdata;


@property (nonatomic,assign)id<PopColumViewDelegate>delegate;
@end

@protocol PopColumViewDelegate <NSObject>

- (void)popColunView:(PopColumView*)view didChooseColums:(NSMutableArray*)items otherItems:(NSMutableArray*)others;

@end

