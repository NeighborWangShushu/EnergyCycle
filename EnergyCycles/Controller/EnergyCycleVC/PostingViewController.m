//
//  PostingViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "PostingViewController.h"

#import "EnergyPostViewCell.h"
#import "EnergyPostOneViewCell.h"
#import "EnergyPostTwoViewCell.h"
#import "ZYQAssetPickerController.h"
#import "EnergyPostCollectionViewCell.h"
#import "ECShareCell.h"
#import "XMTwoShareView.h"

#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"

#import "XMShareWechatUtil.h"
#import "XMShareWeiboUtil.h"
#import "XMShareQQUtil.h"

#import "SDPhotoBrowser.h"
#import "Masonry.h"
#import "ShareModel.h"
#import "ShareSDKManager.h"


@interface PostingViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UIAlertViewDelegate,XHImageViewerDelegate,EnergyPostViewCellDelegate,ECShareCellDelegate,SDPhotoBrowserDelegate,SDPhotoBrowserDelegate,EnergyPostCollectionViewCellDelegate> {
    NSMutableDictionary *postDict;
    NSMutableArray *_dataArr;
    NSMutableArray *_selectImgArray;
    NSMutableArray *_selectImgArrayLocal;
    NSMutableArray *_sharesArray;
    UIButton *rightButton;
    NSInteger _tempIndex;
    
    UIAlertView *delAlertView;
    
    EnergyPostViewCell * energyPostViewCell;
    NSInteger postIndex;
}

@property (nonatomic,strong)NSArray * pics;

@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation PostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initialize];
    [self setup];
    
}

- (void)initialize {
    _selectImgArray = [[NSMutableArray alloc] initWithCapacity:1];
    _selectImgArrayLocal = [[NSMutableArray alloc] initWithCapacity:1];
    _sharesArray = [NSMutableArray array];
    self.title = @"发帖";
    postDict = [[NSMutableDictionary alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatShareSuccess) name:@"wechatShareSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboShareSuccess) name:@"weiboShareSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QQShareSuccess) name:@"QQShareSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCancel) name:@"shareCancel" object:nil];
    
    
    
}

- (void)setup {
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    energyPostViewCell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyPostViewCell" owner:self options:nil] lastObject];
    energyPostViewCell.informationTextView.delegate = self;
    [self.view insertSubview:energyPostViewCell atIndex:0];
    
    
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(60, 60);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[EnergyPostCollectionViewCell class] forCellWithReuseIdentifier:@"EnergyPostCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    
    ECShareCell * shareView = [[[NSBundle mainBundle] loadNibNamed:@"ECShareCell" owner:self options:nil] lastObject];
    shareView.delegate = self;
    [self.view addSubview:shareView];
    
    [energyPostViewCell mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.height.equalTo(@100);
        
    }];
    
    CGFloat height = 45 + (70*([_selectImgArrayLocal count]+1)/5);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(energyPostViewCell.mas_bottom);
        make.height.equalTo(@(height));
    }];
    
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 返回按键
- (void)leftAction {
    if ([postDict count] > 0 || _selectImgArrayLocal.count!=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else {
        [self back];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:delAlertView]) {
        if (buttonIndex == 1) {
            [_selectImgArray removeObjectAtIndex:delAlertView.tag];
            [_selectImgArrayLocal removeObjectAtIndex:delAlertView.tag];
            [self.collectionView reloadData];
        }
    }else {
        if (buttonIndex == 1) {
            [self back];
        }
    }
}


- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    if (![_selectImgArrayLocal count]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"不配图没有积分哦，确认发帖？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submit];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:alert completion:nil];
        }];
        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self submit];
    }
}

- (void)submit {
    NSString * title=[postDict valueForKey:@"title"];
    NSString * context=[postDict valueForKey:@"content"];
    NSLog(@"title:%@----context:%@",title,context);
    if (context == nil ||[context isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
        return;
    }
    if (context.length < 30) {
        [SVProgressHUD showImage:nil status:@"30字以上才能发表哦~"];
        return;
    }
    if ([User_TOKEN length] > 0) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD showWithStatus:@"提交中.."];
        
        if(_selectImgArrayLocal.count) {
            
            NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[0], 0.05);
            [self submitImage:data];
        }else {
            [self getURLContext];
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }
    
}

-(void)getURLContext {
    
    NSString * title=[postDict valueForKey:@"title"];
    NSString * context=[postDict valueForKey:@"content"];
    
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    context = [context stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (context==nil) {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
        return;
    }
    
    NSString *viderUrl = @"";
    if (![postDict valueForKey:@"videoUrl"]) {
        viderUrl = @"";
    }else {
        viderUrl = [postDict valueForKey:@"videoUrl"];
    }
    
    [[AppHttpManager shareInstance] postAddArticleWithTitle:@"" Content:context VideoUrl:viderUrl UserId:[User_ID intValue] token:User_TOKEN List:_dataArr PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [SVProgressHUD showImage:nil status:@"发布成功"];
            postIndex = [[dict objectForKey:@"Data"] integerValue];
            if ([_sharesArray count]) {
                [self share:_sharesArray];
            }else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else {
            [_dataArr removeAllObjects];
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"发布失败 %@",str);
        [SVProgressHUD dismiss];
        [_dataArr removeAllObjects];
    }];
}


-(void)submitImage:(NSData*)imageData {
    
    [[AppHttpManager shareInstance] postPostFileWithImageData:imageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _tempIndex++;
            NSString * imgURL=[dict[@"Data"] firstObject];
            [_dataArr addObject:imgURL];
            NSLog(@"selectImgArrayLocal:%lu",(unsigned long)[_selectImgArrayLocal count]);
            if (_selectImgArrayLocal.count) {// 九张
                if(_tempIndex<_selectImgArrayLocal.count){
                    NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[_tempIndex], 0.05);
                    NSLog(@"_tempIndex:%ld",(long)_tempIndex);
                    [self submitImage:data];
                }else{
                    // 提交数据
                    [self getURLContext];
                }
            }
        }else {
            // 网络出错
            [SVProgressHUD showImage:nil status:@"请检查网络"];
        }
    } failure:^(NSString *str) {
        NSLog(@"错误：%@",str);
        [SVProgressHUD dismiss];
    }];
}



- (void)showImageView:(NSInteger )index
{
    NSLog(@"%ld",[self.collectionView.subviews count]);
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = index;
    browser.sourceImagesContainerView = self.collectionView;
    browser.imageCount = _selectImgArrayLocal.count;
    browser.delegate = self;
    [browser show];
    
}

- (void)updateCollectionHeight {
    CGFloat height = 45 + (70*([_selectImgArrayLocal count]+1)/5);
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(energyPostViewCell.mas_bottom);
        make.height.equalTo(@(height));
    }];
}


#pragma mark ShareSuccess

- (void)QQShareSuccess {
    [_sharesArray removeObjectAtIndex:0];
    if ([_sharesArray count]) {
        NSNumber*num = _sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}

- (void)wechatSessionShareSuccess {
    
    [_sharesArray removeObjectAtIndex:0];
    if ([_sharesArray count]) {
        NSNumber*num = _sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
    
}

- (void)wechatTimeLineShareSuccess {
    
    [_sharesArray removeObjectAtIndex:0];
    if ([_sharesArray count]) {
        NSNumber*num = _sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
    
}

- (void)weiboShareSuccess {
    [_sharesArray removeObjectAtIndex:0];
    if ([_sharesArray count]) {
        NSNumber*num = _sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}

- (void)shareNext {
    
    [_sharesArray removeObjectAtIndex:0];
    if ([_sharesArray count]) {
        NSNumber*num = _sharesArray[0];
        [self shareByIndex:[num integerValue]];
    }else {
        [self shareCancel];
    }
}


#pragma mark Share

- (void)shareCancel {
    
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)shareToWechatTimeline:(NSString*)url title:(NSString*)title {
    
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeixinTimeLine:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf wechatTimeLineShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                break;
                
            default:
                break;
        }
    }];
}

- (void)shareToWechatSession:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeixinSession:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf wechatSessionShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                
                break;
                
            default:
                break;
        }
    }];
}

- (void)shareToWeibo:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToWeibo:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf weiboShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                break;
                
            default:
                break;
        }
    }];
    
    
}

- (void)shareToQQ:(NSString*)url title:(NSString*)title {
    
    __weak __typeof(self)weakSelf = self;
    
    ShareModel*model = [[ShareModel alloc] init];
    model.title = title;
    model.content = @"";
    model.shareUrl = url;
    [[ShareSDKManager shareInstance] shareClientToQQSession:model block:^(SSDKResponseState state) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [weakSelf QQShareSuccess];
            }
                break;
            case SSDKResponseStateCancel:
                [weakSelf shareCancel];
                
                break;
                
            default:
                break;
        }
    }];
    
}


#pragma mark UICollectionViewDelegate

- (void)share:(NSMutableArray*)items {
    
    [SVProgressHUD showWithStatus:@""];
    NSNumber*num = items[0];
    [self shareByIndex:[num integerValue]];
    
}

- (void)shareByIndex:(NSInteger)index {
    
    NSString * title = energyPostViewCell.informationTextView.text;
    NSString* share_url = [NSString stringWithFormat:@"%@%@?aid=%@&is_Share=1",INTERFACE_URL,ArticleDetailAspx,[NSString stringWithFormat:@"%ld",(long)postIndex]];
    
    switch (index) {
        case 0:
            [self shareToWechatTimeline:share_url title:title];
            break;
        case 1:
            [self shareToWechatSession:share_url title:title];
            break;
        case 2:
            [self shareToWeibo:share_url title:title];
            break;
        case 3:
            [self shareToQQ:share_url title:title];
            break;
            
        default:
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_selectImgArrayLocal count]) {
        [self didAddPic];
    }else {
        [self showImageView:indexPath.row];
    }
}

- (void)didLongpressedImage:(NSInteger)index {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"确认要删除该图片吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *  action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
        [_selectImgArray removeObjectAtIndex:index];
        [_selectImgArrayLocal removeObjectAtIndex:index];
        [self.collectionView reloadData];
        [self updateCollectionHeight];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark --UICollectionViewDataSource

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCell";
    EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    if (indexPath.row != [_selectImgArrayLocal count]) {
        [cell.showImageView setImage:_selectImgArrayLocal[indexPath.row]];
    }else {
        [cell.showImageView setImage:[UIImage imageNamed:@"Rectangle "]];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectImgArrayLocal.count == 9) {
        return [_selectImgArrayLocal count];
    }
    return _selectImgArrayLocal.count + 1;
}

- (UIImage*)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return _selectImgArrayLocal[index];
    
}

#pragma mark --EnergyPostViewCellDelegate

/**
 *  添加照片
 */
- (void)didAddPic {
    [self clickToShow];
}


#pragma mark --ECShareCellDelegate

- (void)didChooseShareItems:(NSMutableArray *)items {
    
    //    NSString * context=[postDict valueForKey:@"content"];
    _sharesArray = items;
    
}

#pragma mark - textField值改变
- (void)textFieldValueChange:(UITextField *)textField {
    if ([textField.text length] > 20) {
        [SVProgressHUD showImage:nil status:@"标题字数已到上限"];
        textField.text = [textField.text substringToIndex:20];
    }
    
    [postDict setObject:textField.text forKey:@"title"];
}

#pragma mark --获取音频路径
-(void)getVideoURL:(UITextField *)text {
    [postDict setObject:text.text forKey:@"videoUrl"];
}

#pragma mark - textView值改变
- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] > 800) {
        [SVProgressHUD showImage:nil status:@"内容字数已到上限"];
        textView.text = [textView.text substringToIndex:800];
    }
    
    NSString *textViewStr = @"";
    if ([textView.text rangeOfString:@"\n"].location != NSNotFound) {
        textViewStr = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    }else {
        textViewStr = textView.text;
    }
    [postDict setObject:textViewStr forKey:@"content"];
}

//点击选择图片 入口
-(void)clickToShow{
    [self.view endEditing:YES];
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: NSLocalizedString(@"从相册选取", nil), NSLocalizedString(@"拍照", nil),nil];
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        // 选择拍照
        [self takePhoto:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex==0){
        // 获取本地图片
        [self LocalPhoto];
    }
}

-(void)takePhoto:(NSInteger)type{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = type;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: type]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        if (type == UIImagePickerControllerSourceTypeCamera) {
            picker.allowsEditing = YES;
        }
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

-(void)LocalPhoto{
    NSInteger count = 0;
    NSLog(@"_selectImgArray %ld",(long)_selectImgArray.count);
    if (_selectImgArray != nil && _selectImgArray.count > 0) {
        count =_selectImgArray.count;
    }
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.navigationBar.tintColor=[UIColor redColor];
    picker.navigationBar.translucent = NO;
    picker.maximumNumberOfSelection = 9-count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectImgArrayLocal addObject:image];
    [self updateCollectionHeight];
    [self.collectionView reloadData];
}

//相册
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if(assets!=nil&&assets.count>0){
        //创建临时存储目录
        for(int i=0;i<assets.count;i++){
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [_selectImgArrayLocal addObject:tempImg];
            [_selectImgArray addObject:tempImg];
            [self.collectionView reloadData];
            [self updateCollectionHeight];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)cancel:(id)sender {
    [self leftAction];
}

- (IBAction)push:(id)sender {
    [self rightAction];
    
}
@end