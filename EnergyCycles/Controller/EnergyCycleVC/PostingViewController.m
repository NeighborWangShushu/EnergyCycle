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

@interface PostingViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UIAlertViewDelegate,XHImageViewerDelegate,EnergyPostViewCellDelegate,ECShareCellDelegate> {
    NSMutableDictionary *postDict;
    NSMutableArray *_dataArr;
    NSMutableArray *_selectImgArray;
    NSMutableArray *_selectImgArrayLocal;
    UIButton *rightButton;
    NSInteger _tempIndex;
    
    UIAlertView *delAlertView;
}

@end

@implementation PostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _selectImgArray = [[NSMutableArray alloc] initWithCapacity:1];
    _selectImgArrayLocal = [[NSMutableArray alloc] initWithCapacity:1];
    self.title = @"发帖";
    postDict = [[NSMutableDictionary alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    energyPostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    energyPostTableView.showsVerticalScrollIndicator = NO;
    energyPostTableView.backgroundColor = [UIColor clearColor];
    
    [self setupLeftNavBarWithimage:@"blackback_normal.png"];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:81/255.0 green:171/255.0 blue:241/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
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
            [energyPostTableView reloadData];
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
    NSString * title=[postDict valueForKey:@"title"];
    NSString * context=[postDict valueForKey:@"content"];
    NSLog(@"title:%@----context:%@",title,context);
    if (context == nil ||[context isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"内容不能为空"];
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
    
    if (title==nil||context==nil) {
        [SVProgressHUD showImage:nil status:@"内容或标题不能为空"];
        return;
    }
    
    NSString *viderUrl = @"";
    if (![postDict valueForKey:@"videoUrl"]) {
        viderUrl = @"";
    }else {
        viderUrl = [postDict valueForKey:@"videoUrl"];
    }
    
    [[AppHttpManager shareInstance] postAddArticleWithTitle:title Content:context VideoUrl:viderUrl UserId:[User_ID intValue] token:User_TOKEN List:_dataArr PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            [SVProgressHUD showImage:nil status:@"发布成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showImage:nil status:dict[@"Msg"]];
        }
    } failure:^(NSString *str) {
        NSLog(@"发布失败 %@",str);
        [SVProgressHUD dismiss];
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

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 308.f;
    }else if (indexPath.row == 1) {
        return 50.0f;
    }
    
    return 50.f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        EnergyPostViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyPostViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pics = _selectImgArrayLocal;
        cell.delegate = self;
        NSString *showText = [postDict[@"content"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        
        cell.informationTextView.text = showText;
        cell.informationTextView.delegate = self;
        
        return cell;
    }else {
        
        ECShareCell*cell = [[[NSBundle mainBundle] loadNibNamed:@"ECShareCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        
        
        
        
        return cell;
    }
    
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
    
    NSString * context=[postDict valueForKey:@"content"];

    
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

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(_selectImgArrayLocal.count<9){
        return _selectImgArrayLocal.count+1;
    }else{
        return _selectImgArrayLocal.count;
    }
    return 1;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCellId";
    EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyPostCollectionViewCell" owner:self options:nil] lastObject];
    }
   
    if (_selectImgArrayLocal.count==0) {
        [cell.showJiaImageView setImage:[UIImage imageNamed:@"jia_normal.png"]];
        [cell.showImageView setImage:[UIImage imageNamed:@"Rectangle .png"]];
    }else{
       [cell.showJiaImageView setImage:[UIImage imageNamed:@""]];
    }
    
    if (_selectImgArrayLocal.count) {
         if (_selectImgArrayLocal.count<9) {
             if (indexPath.item==_selectImgArrayLocal.count) {
                 [cell.showJiaImageView setImage:[UIImage imageNamed:@"jia_normal.png"]];
                 [cell.showImageView setImage:[UIImage imageNamed:@"Rectangle .png"]];
             }else{
                 [cell.showImageView setImage:_selectImgArrayLocal[indexPath.item]];
             }
        }else {
            //最后一张是图片
           [cell.showImageView setImage:_selectImgArrayLocal[indexPath.item]];
        }
    }
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

#pragma mark - 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark ---  获取图片资源
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectImgArrayLocal.count) {
        [self clickToShow];
    }else {//图片浏览
        NSMutableArray *sumImageArr = [[NSMutableArray alloc] init];
        for (UIImage *getImage in _selectImgArrayLocal) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = getImage;
            [sumImageArr addObject:imageView];
        }
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
        imageViewer.delegate = self;
        [imageViewer showWithImageViews:sumImageArr selectedView:sumImageArr[indexPath.row]];
    }
}

#pragma mark - 长按手势响应事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (longPress.view.tag != _selectImgArray.count) {
        if (longPress.state == UIGestureRecognizerStateEnded) {
            delAlertView = [[UIAlertView alloc] initWithTitle:@"确认移除照片吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            delAlertView.tag = longPress.view.tag;
            [delAlertView show];
        }
    }
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
    picker.navigationBar.tintColor=[UIColor whiteColor];
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
    [energyPostTableView reloadData];
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
        }
    }
    [energyPostTableView reloadData];
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    
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
