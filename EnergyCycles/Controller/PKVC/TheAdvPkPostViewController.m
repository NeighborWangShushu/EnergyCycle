//
//  TheAdvPkPostViewController.m
//  EnergyCycles
//
//  Created by Adinnet_Mac on 15/12/1.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "TheAdvPkPostViewController.h"

#import "ChooseClassificationViewCell.h"
#import "EnergyPostViewCell.h"
#import "EnergyPostOneViewCell.h"
#import "EnergyPostCollectionViewCell.h"
#import "EnergyPostTwoViewCell.h"
#import "HeadLineTableViewCell.h"
#import "ZYQAssetPickerController.h"
#import "CustomChooseClassView.h"

#import "XMTwoShareView.h"

#import "XHImageViewer.h"
#import "UIImageView+XHURLDownload.h"

@interface TheAdvPkPostViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate,UIActionSheetDelegate,XHImageViewerDelegate> {
    NSMutableDictionary *postDict;
    NSMutableArray *_dataArr;
    
    CustomChooseClassView *customChooseClassView;
    NSMutableArray * _selectImgArrayLocal;
    NSMutableArray * _selectImgArray;
    UIButton *rightButton;
    NSInteger _tempIndex;
    
    XMTwoShareView *shareView;
    UIAlertView *delAlertView;
    
    BOOL isImage;
}

@end

@implementation TheAdvPkPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    postDict = [[NSMutableDictionary alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    _selectImgArrayLocal=[NSMutableArray array];
    _selectImgArray=[NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:240/255.0 alpha:1];
    pkPostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pkPostTableView.showsVerticalScrollIndicator = NO;
    pkPostTableView.backgroundColor = [UIColor clearColor];
    
    [self setupLeftNavBarWithimage:@"loginfanhui"];
    
    self.title = @"进阶PK汇报";
    
    rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 35, 30);
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
    //增加消息中心,移除分享界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShareView:) name:@"NotificationRemoveShareView" object:nil];
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
            [pkPostTableView reloadData];
        }
    }else {
        if (buttonIndex == 1) {
            [self back];
        }
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-white.png"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top-blue.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial-Bold" size:0.0]}];
}

#pragma mark - 提交按键响应事件
- (void)rightAction {
    if ([User_TOKEN length] > 0) {
        if(_selectImgArrayLocal.count){
            NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[0], 0.05);
            [self submitImage:data];
        }else{
            [self getURLContext];
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AllVCNotificationTabBarConToLoginView" object:nil];
    }
}

#pragma mark - 创建View
- (void)creatSuccessShareView {
    [SVProgressHUD dismiss];
    //分享
    shareView = [[XMTwoShareView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height) withTitle:@"进阶汇报提交成功"];
    shareView.alpha = 0.0;
    shareView.shareTitle = [postDict[@"title"] stringByRemovingPercentEncoding];
    shareView.shareText = [postDict[@"information"] stringByRemovingPercentEncoding];
    shareView.shareUrl = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",MYJYAppId];
    shareView.isImage = isImage;
    
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareView.alpha = 1.0;
    }];
}

//实现消息中心方法
- (void)removeShareView:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
    
    [shareView removeFromSuperview];
}

- (void)submitImage:(NSData*)imageData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:@"提交中.."];
    
    [[AppHttpManager shareInstance] postPostFileWithImageData:imageData PostOrGet:@"post" success:^(NSDictionary *dict) {
        if ([dict[@"Code"] integerValue] == 200 && [dict[@"IsSuccess"] integerValue] == 1) {
            _tempIndex++;
            NSString * imgURL=[dict[@"Data"] firstObject];
            [_dataArr addObject:imgURL];
            if (_selectImgArrayLocal.count) {// 九张
                if(_tempIndex<_selectImgArrayLocal.count){
                    NSData * data=UIImageJPEGRepresentation(_selectImgArrayLocal[_tempIndex], 0.05);
                    [self submitImage:data];
                }else{
                    // 提交数据
                    [self getURLContext];
                }
            }
        }else {
            // 网络出错
            
        }
    } failure:^(NSString *str) {
        NSLog(@"错误：%@",str);
        [SVProgressHUD dismiss];
    }];
}

- (void)getURLContext {
    NSString *postTypeId = postDict[@"fenlei"];
    NSString *title = postDict[@"title"];
    NSString *context = postDict[@"information"];
    
    title = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    context = [context stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *videoUrl=[NSString stringWithFormat:@"%@",[postDict valueForKey:@"videoUrl"]];
    
    if (postTypeId == nil || [postTypeId isKindOfClass:[NSNull class]] || [postTypeId isEqual:[NSNull null]] || [postTypeId length] <= 0) {
        [SVProgressHUD showImage:nil status:@"请选择分类"];
    }else if (title == nil || context == nil) {
        [SVProgressHUD showImage:nil status:@"内容或标题不能为空"];
    }else {
        if (_dataArr.count) {
            isImage = YES;
        } else {
            isImage = NO;
        }
        
        [[AppHttpManager  shareInstance] getAddPostWithPostTypeId:[postTypeId intValue] Title:title Content:context videoUrl:videoUrl userId:[User_ID intValue] token:User_TOKEN postPic:_dataArr PostOrGet:@"post" success:^(NSDictionary *dict) {
            [self creatSuccessShareView];
        } failure:^(NSString *str) {
            
            NSLog(@"%@",str);
        }];
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50.f;
    } else if (indexPath.row == 1) {
        return 30.f;
    } else if (indexPath.row == 2) {
        return 308.f;
    }else if (indexPath.row == 3) {
        return 120.f;
    }
    
    return 50.f;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChooseClassificationViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ChooseClassificationViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       if (postDict[@"fenlei"]) {
         cell.titleLabel.text=postDict[@"fenleiText"];
       }
        return cell;
    } else if (indexPath.row == 1) {
        HeadLineTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"HeadLineTableViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.text = postDict[@"title"];
        
        return cell;
    } else if (indexPath.row == 2) {
        EnergyPostViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyPostViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.titleTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        cell.titleTextField.text=postDict[@"title"];
        
        NSString *showText = [postDict[@"information"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        cell.informationTextView.text = showText;
        cell.informationTextView.delegate = self;
        
        return cell;
    }else if (indexPath.row == 3) {
        EnergyPostOneViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyPostOneViewCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 10.f;
        layout.minimumLineSpacing = 10.f;
        cell.showImageCollectionView.collectionViewLayout = layout;
        cell.showImageCollectionView.backgroundColor = [UIColor clearColor];
        [cell.showImageCollectionView registerNib:[UINib nibWithNibName:@"EnergyPostCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"EnergyPostCollectionViewCellId"];
        cell.showImageCollectionView.dataSource = self;
        cell.showImageCollectionView.delegate = self;
        
        return cell;
    }
    
    EnergyPostTwoViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"EnergyPostTwoViewCell" owner:self options:nil].lastObject;
     [cell.videoURlTextFiled addTarget:self action:@selector(getVideoURL:) forControlEvents:UIControlEventEditingChanged];
    cell.videoURlTextFiled.text=postDict[@"videoUrl"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        customChooseClassView = [[CustomChooseClassView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_Height)];
        customChooseClassView.alpha = 0;
        
        __unsafe_unretained __typeof(self) weakSelf = self;
        [customChooseClassView setChooseClassStr:^(NSString *str,NSString *typeID) {
            [weakSelf getChooseWithStr:str typeId:typeID];
        }];
        
        [[UIApplication sharedApplication].keyWindow addSubview:customChooseClassView];
        [UIView animateWithDuration:0.25 animations:^{
            customChooseClassView.alpha = 1;
        }];
    }
}

#pragma mark - 获取选择的分类
- (void)getChooseWithStr:(NSString *)str typeId:(NSString *)Id{
    [customChooseClassView removeFromSuperview];
    
    if (![str isEqualToString:@" "]) {
        ChooseClassificationViewCell *cell = [pkPostTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.titleLabel.text = str;
        [postDict setObject:Id forKey:@"fenlei"];
        [postDict setObject:str forKey:@"fenleiText"];
    }
}

#pragma mark - textField值改变
- (void)textFieldValueChange:(UITextField *)textField {
    if ([textField.text length] > 20) {
        [SVProgressHUD showImage:nil status:@"标题字数已到上限"];
        textField.text = [textField.text substringToIndex:20];
    }
    
    [postDict setObject:textField.text forKey:@"title"];
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
    [postDict setObject:textViewStr forKey:@"information"];
}

#pragma  mark--- 视屏地址
-(void)getVideoURL:(UITextField*)textField{
    [postDict setObject:textField.text forKey:@"videoUrl"];
}

#pragma mark - 实现UIcollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectImgArrayLocal.count) {
        if (_selectImgArrayLocal.count==9) {
            return 9;
        }
        return _selectImgArrayLocal.count+1;
    }
    return 1;
}

#pragma mark - 定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - 定义每个UICollectionView的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

#pragma mark - 填充collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *EnergyPostCollectionViewCellId = @"EnergyPostCollectionViewCellId";
    EnergyPostCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EnergyPostCollectionViewCellId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EnergyPostCollectionViewCell" owner:self options:nil] lastObject];
    }
    // 设置图片
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
            
        }else{
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

#pragma mark - UICollectionView点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item==_selectImgArrayLocal.count) {
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

#pragma  mark 获取图片资源
//点击选择图片 入口
- (void)clickToShow {
    [self.view endEditing:YES];
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: NSLocalizedString(@"从相册选择", nil), NSLocalizedString(@"拍照", nil),nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        // 选择拍照
        [self takePhoto:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex==0){
        // 获取本地图片
        [self LocalPhoto];
    }
}

- (void)takePhoto:(NSInteger)type {
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
//        [self presentViewController:picker animated:YES completion:nil];
        [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

- (void)LocalPhoto {
    NSInteger count = 0;
    if (_selectImgArray != nil && _selectImgArray.count >0) {
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
//    [self presentViewController:picker animated:YES completion:nil];
    [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_selectImgArrayLocal addObject:image];
    [pkPostTableView reloadData];
}
//相册
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if(assets!=nil&&assets.count>0){
        //创建临时存储目录
        for(int i=0;i<assets.count;i++){
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [_selectImgArrayLocal addObject:tempImg];
            [_selectImgArray addObject:tempImg];
        }
    }
    [pkPostTableView reloadData];
}

#pragma mark - XHImageViewerDelegate
- (void)imageViewer:(XHImageViewer *)imageViewer willDismissWithSelectedView:(UIImageView *)selectedView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
