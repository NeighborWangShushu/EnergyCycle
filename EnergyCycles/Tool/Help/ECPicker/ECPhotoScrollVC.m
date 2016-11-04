//
//  ECPhotoScrollVC.m
//  EnergyCycles
//
//  Created by 王斌 on 2016/10/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ECPhotoScrollVC.h"

#define kScrollViewWidth self.scrollView.frame.size.width
#define kScrollViewHeight  self.scrollView.frame.size.height
#define CALCULATE_NUMBER(x,y) (x+y)%y // 图片的序号

@interface ECPhotoScrollVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ECPhotoScrollVC

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        self.imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (void)viewDidLoad {
//    [self createPhotoScrollView];
    [self setLayout];
    self.page = self.indexPath.row;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", self.page + 1, self.albumData.count];
    
    // Do any additional setup after loading the view.
}

- (void)setLayout {
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height - 64)];
    // 接受代理
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, self.scrollView.frame.origin.y);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScrollViewWidth, kScrollViewHeight)];
    self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScrollViewWidth, 0, kScrollViewWidth, kScrollViewHeight)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * kScrollViewWidth, 0, kScrollViewWidth, kScrollViewHeight)];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.middleImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    // 整页翻动
    self.scrollView.pagingEnabled = YES;
    // 关闭横向滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 关闭垂直滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.scrollView];
    
    [self setScrollViewImage:self.indexPath.row];
}

// 设置图片
- (void)setScrollViewImage:(NSInteger)imageNumber {
    [self getImageWithImageView:self.leftImageView Index:CALCULATE_NUMBER(imageNumber - 1, self.albumData.count)];
    [self getImageWithImageView:self.rightImageView Index:CALCULATE_NUMBER(imageNumber + 1, self.albumData.count)];
    [self getImageWithImageView:self.middleImageView Index:CALCULATE_NUMBER(imageNumber, self.albumData.count)];
}

// 获取图片
- (void)getImageWithImageView:(UIImageView *)imageView Index:(NSInteger)index {
    NSLog(@"%ld",index);
    PHAsset *asset = self.albumData[index];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(Screen_width, Screen_Height) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        imageView.image = result;
    }];
}

- (void)setPageTitle {
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", self.page + 1, self.albumData.count];
}

- (void)createPhotoScrollView {
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height - 64)];
    // 接受代理
    self.scrollView.delegate = self;
    // 内容视图大小
    self.scrollView.contentSize = CGSizeMake(self.albumData.count * Screen_width, Screen_Height - 64);
    // 滚动视图偏移量
    self.scrollView.contentOffset = CGPointMake(self.indexPath.row * Screen_width, 0);
    // 设置背景色
    self.scrollView.backgroundColor = [UIColor whiteColor];

//    // 最大缩放比例
//    self.scrollView.maximumZoomScale = 2.0;
//    // 最小缩放比例
//    self.scrollView.minimumZoomScale = 1.0;
    // 整页翻动
    self.scrollView.pagingEnabled = YES;
    // 关闭横向滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 关闭垂直滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    // 关闭回弹效果
//    self.scrollView.bounces = NO;
    
    [self addImageView];
    
    [self.view addSubview:self.scrollView];
}

- (void)addImageView {
    for (int i = 0; i < self.albumData.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height - 64)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.userInteractionEnabled = YES;
        PHAsset *asset = self.albumData[i];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(Screen_width, Screen_Height) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            imageView.image = result;
        }];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(Screen_width * i, 0, Screen_width, Screen_Height -64)];
//        scroll.contentSize = CGSizeMake(Screen_width, Screen_Height);
        scroll.delegate = self;
        // 最大缩放比例
        self.scrollView.maximumZoomScale = 2.0;
        // 最小缩放比例
        self.scrollView.minimumZoomScale = 1.0;
        [scroll addSubview:imageView];
        [self.scrollView addSubview:scroll];
    }
}

#pragma mark -----ScrollViewDelegate-----

// 结束滚动时触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = self.scrollView.contentOffset;
    if (offset.x >= 2 * kScrollViewWidth) {
        self.page = CALCULATE_NUMBER(self.page + 1, self.albumData.count);
    } else if (offset.x == 0) {
        self.page = CALCULATE_NUMBER(self.page - 1, self.albumData.count);
    } else {
        return;
    }
    [self setScrollViewImage:self.page];
    [self setPageTitle];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, self.scrollView.frame.origin.y);
//    self.page = offset.x / Screen_width;
//    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", self.page + 1, self.albumData.count];
//    if (scrollView.zoomScale != 1.0) {
//        scrollView.zoomScale = 1.0;
//    }
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    NSLog(@"%@ ....... %@", NSStringFromCGPoint(scrollView.contentOffset), NSStringFromCGPoint(self.scrollView.contentOffset));
//    return [scrollView.subviews firstObject];
////    return [scrollView.subviews[self.page].subviews firstObject];
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
////    UIImageView *imageView = [scrollView.subviews[self.page].subviews firstObject];
//    UIImageView *imageView = [scrollView.subviews firstObject];
//    if (scrollView.zoomScale <= 1.0) {
//        imageView.center = scrollView.subviews[self.page].center;
//    }
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
