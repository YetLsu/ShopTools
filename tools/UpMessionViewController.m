//
//  UpMessionViewController.m
//  tools
//
//  Created by guest on 16/8/24.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "UpMessionViewController.h"
#import "UpMessionViewCell.h"
#import "ScanImageViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ShopMession.h"
#import "Database.h"
#import "AFNetworking.h"
#import "MD5.h"
#import "MBProgressHUD.h"
#import "UIView+NFExtension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface UpMessionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScanImageViewControllerDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) UICollectionView *shopCollectionView;
//@property (nonatomic, strong) UICollectionView *shopOuterCollection;
@property (nonatomic, strong) NSMutableArray *shopOuterData;

//@property (nonatomic, strong) UICollectionView *shopInnerCollection;
@property (nonatomic, strong) NSMutableArray *shopInnerData;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
//判断当前选中的是outer还是inner
@property (nonatomic, assign) BOOL isOuter;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) NSInteger distance;
//是否保存到本地或者已经上传
@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, strong) UITextView *markView;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) CLLocation *userLocation;

//经纬度的标签
@property (nonatomic, strong) UILabel *lonLabel;
@property (nonatomic, strong) UILabel *latLabel;

@property (nonatomic, assign) BOOL isKeyboardShow;
@end

@implementation UpMessionViewController

- (NSMutableArray *)shopInnerData{
    if (_shopInnerData == nil) {
        _shopInnerData = [NSMutableArray array];
    }
    return _shopInnerData;
}

- (NSMutableArray *)shopOuterData{
    if (_shopOuterData == nil) {
        _shopOuterData = [NSMutableArray array];
    }
    return _shopOuterData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_shopMession == nil) {
        _shopMession = [[ShopMession alloc] init];
    }
    
    [self setupNavi];
    
    [self setupContent];
    
    [self setupData];
    
    [self location];
    
}

- (void)setupNavi{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.155 green:0.4285 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;

}
- (void)back{
    if(!_isSave && (_shopInnerData.count != 0 || _shopOuterData.count != 0)){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有保存或者上传任务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)location{
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    _userLocation = location;
    _distance = [location distanceFromLocation:_shopLocation];
    _shopMession.shopLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    _shopMession.shopLon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    _latLabel.text = [NSString stringWithFormat:@"纬度：%f",location.coordinate.latitude];
    _lonLabel.text = [NSString stringWithFormat:@"经度：%f",location.coordinate.longitude];
    
}


- (void)setupData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideOrShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideOrShow:) name:UIKeyboardWillHideNotification object:nil];
    _shopMession.shopType = _wrongType;
    if([_wrongType isEqualToString:@"新店"]){
        NSString *timeString = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
        NSString *shopMD = [MD5 md5: timeString];
        self.shopMession.shopId = [[MD5 md5: shopMD] uppercaseString];
    }
}

//获取当前时间
- (NSDate *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (void)setupContent{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6];
    [self.view addSubview:_scrollView];
    CGFloat itemWidth = (kScreenWidth - 4 * 12)/3;
    CGFloat itemHeight = 120;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    _shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 64, kScreenWidth-24, 320) collectionViewLayout:layout];
    _shopCollectionView.delegate = self;
    _shopCollectionView.dataSource = self;
    _shopCollectionView.backgroundColor = [UIColor clearColor];
    [_shopCollectionView registerClass:[UpMessionViewCell class] forCellWithReuseIdentifier:@"upMessionViewCellId"];
    [_shopCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_scrollView addSubview:_shopCollectionView];
    
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _maskView.backgroundColor = [UIColor colorWithRed:0.356 green:0.356 blue:0.356 alpha:0.29];
    _maskView.hidden = YES;
    [_scrollView addSubview:_maskView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_maskView addGestureRecognizer:tapGR];
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_shopCollectionView.frame), kScreenWidth - 24, 40)];
    markLabel.text = @"备注:";
    markLabel.font = [UIFont boldSystemFontOfSize:18];
    [_scrollView addSubview: markLabel];
    _markView = [[UITextView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(markLabel.frame), kScreenWidth - 24, 100)];
    _markView.backgroundColor = [UIColor whiteColor];
    _markView.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:_markView];
    
    _lonLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_markView.frame) + 5, kScreenWidth - 24, 30)];
    _lonLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:_lonLabel];
    
    _latLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_lonLabel.frame) + 5, kScreenWidth - 24, 30)];
    _latLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:_latLabel];
    
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存至本地" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.frame = CGRectMake(0, kScreenHeight - 44, (kScreenWidth - 10)/2, 44);
    saveBtn.backgroundColor = [UIColor colorWithRed:0.1539 green:0.7541 blue:1.0 alpha:1.0];
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn setTitle:@"立即提交" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uploadBtn.frame = CGRectMake((kScreenWidth - 10)/2 + 10, kScreenHeight - 44, (kScreenWidth - 10)/2, 44);
    uploadBtn.backgroundColor = [UIColor colorWithRed:0.1539 green:0.7541 blue:1.0 alpha:1.0];
    [uploadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    
    
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePickerController.delegate = self;
    
    
    
}

#pragma mark Mession
- (void)tapAction:(UITapGestureRecognizer *)tap{
    _maskView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)keyboardHideOrShow:(NSNotification *)notification{
    if (_isKeyboardShow && [notification name] == UIKeyboardWillShowNotification) {
        return;
    }
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([notification name] == UIKeyboardWillShowNotification) {
        _maskView.hidden = NO;
        _isKeyboardShow = YES;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = _scrollView.frame;
            rect.origin.y -= keyboardRect.size.height;
            _scrollView.frame = rect;
        }];
    }else{
        _maskView.hidden = YES;
        _isKeyboardShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = _scrollView.frame;
            rect.origin.y += keyboardRect.size.height;
            _scrollView.frame = rect;
        }];
    }


}
- (void)saveAction:(UIButton *)button{
    
    if ([self checkIfWrong]) {
        return;
    }
    if ([self.wrongType isEqualToString:@"新店"]) {
        self.shopMession.shopName = _markView.text;
    }
    self.shopMession.about = _markView.text;
    self.shopMession.creat_time = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
//将图片数组中的image转成base64Image的字符串
    [self base64Image];
//  保存到数据库中
    BOOL result = [[Database database]addShopMession:_shopMession];
    if (result) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存到本地成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        _isSave = YES;
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存到本地失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
//将图片数组中的image转成base64Image的字符串
- (void)base64Image{
    if (_shopOuterData.count > 0) {
        for (UIImage *image in _shopOuterData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [_shopMession.shopOuterImages addObject:imageStr];
        }
    }
    if (_shopInnerData.count > 0) {
        for (UIImage *image in _shopInnerData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [_shopMession.shopInnerImages addObject:imageStr];
        }
    }
}
- (BOOL)checkIfWrong{
    if (_isSave) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经保存到本地成功，请不要多次保存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    if (_shopOuterData.count == 0 && _shopInnerData.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有拍照" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    if([_wrongType isEqualToString:@"新店"] && _markView.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前店为新店，请在备注中写下店名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    return NO;

}
- (void)uploadAction:(UIButton *)button{
    if ([self checkIfWrong]) {
        return;
    }
    if ([self.wrongType isEqualToString:@"新店"]) {
        self.shopMession.shopName = _markView.text;
    }
    self.shopMession.about = _markView.text;
    self.shopMession.creat_time = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
    
    //将图片数组中的image转成base64Image的字符串
    [self base64Image];
    MBProgressHUD *hud = [self.view createHUDWithTitle:@"上传中..."];
    NSString *url = @"http://app.guonongda.com:8080/st/saveshop.do";
    NSString *outerImageString = [_shopMession.shopOuterImages componentsJoinedByString:@","];
    NSString *innerImageString = [_shopMession.shopInnerImages componentsJoinedByString:@","];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[_shopMession.shopType dataUsingEncoding:NSUTF8StringEncoding] name:@"shopType"];
        [formData appendPartWithFormData:[_shopMession.shopName dataUsingEncoding:NSUTF8StringEncoding] name:@"shopName"];
        [formData appendPartWithFormData:[_shopMession.shopId dataUsingEncoding:NSUTF8StringEncoding] name:@"shopId"];
        [formData appendPartWithFormData:[_shopMession.creat_time dataUsingEncoding:NSUTF8StringEncoding] name:@"creat_time"];
        [formData appendPartWithFormData:[_shopMession.shopLon dataUsingEncoding:NSUTF8StringEncoding] name:@"shopLon"];
        [formData appendPartWithFormData:[_shopMession.shopLat dataUsingEncoding:NSUTF8StringEncoding] name:@"shopLat"];
        [formData appendPartWithFormData:[userId dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
        [formData appendPartWithFormData:[outerImageString dataUsingEncoding:NSUTF8StringEncoding] name:@"shopOuterImages"];
        [formData appendPartWithFormData:[innerImageString dataUsingEncoding:NSUTF8StringEncoding] name:@"shopInnerImages"];
        [formData appendPartWithFormData:[_shopMession.about dataUsingEncoding:NSUTF8StringEncoding] name:@"about"];
    } error:nil];
    _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    _manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [[_manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            hud.labelText = @"上传成功";
            [hud hide:YES afterDelay:0.2];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if (error) {
            _isSave = NO;
            hud.labelText = @"上传失败";
            [hud hide:YES afterDelay:0.3];
        }
        
    }] resume];

    
}

#pragma mark CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if(self.shopOuterData.count < 3){
            return self.shopOuterData.count + 1;
        }else{
            return 3;
        }
    }else {
        if(self.shopInnerData.count < 3){
            return self.shopInnerData.count + 1;
        }else{
            return 3;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UpMessionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upMessionViewCellId" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == _shopOuterData.count && _shopOuterData.count < 3) {
            cell.shopImageView.image = [UIImage imageNamed:@"circle_add_photo"];
            
        }else {
            cell.shopImageView.image = _shopOuterData[indexPath.row];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == _shopInnerData.count && _shopInnerData.count < 3) {
            cell.shopImageView.image = [UIImage imageNamed:@"circle_add_photo"];
        }else {
            cell.shopImageView.image = _shopInnerData[indexPath.row];
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    label.font = [UIFont systemFontOfSize:15];
    [reusableView addSubview:label];
    if (indexPath.section == 0) {
        label.text = @"请拍下门店图";
    }else{
        label.text = @"请拍下店内图";
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //距离判断
    if ([_wrongType isEqualToString:@"定位准确"] && _distance > 50) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前距离较远，请走近拍摄" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    
    if (indexPath.section == 0) {
        _isOuter = YES;
        if (indexPath.row != _shopOuterData.count) {
            ScanImageViewController *photoScanVC = [[ScanImageViewController alloc] init];
            photoScanVC.datasource = _shopOuterData;
            photoScanVC.selectedIndexPath = indexPath;
            photoScanVC.delegate = self;
            [self.navigationController pushViewController:photoScanVC animated:YES];
        }else{
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }else{
        _isOuter = NO;
        if (indexPath.row != _shopInnerData.count) {
            ScanImageViewController *photoScanVC = [[ScanImageViewController alloc] init];
            photoScanVC.datasource = _shopInnerData;
            photoScanVC.selectedIndexPath = indexPath;
            photoScanVC.delegate = self;
            [self.navigationController pushViewController:photoScanVC animated:YES];
        }else{
            
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
    }
}

//头视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 40);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_imagePickerController dismissViewControllerAnimated:YES completion:nil];
    if (_isOuter) {
        [self.shopOuterData addObject:info[UIImagePickerControllerOriginalImage]];
        
    }else{
        [self.shopInnerData addObject:info[UIImagePickerControllerOriginalImage]];
        
    }
    
    [_shopCollectionView reloadData];
    
}

- (void)getDatasource:(NSMutableArray *)datasource{
    [_shopCollectionView reloadData];
}





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
