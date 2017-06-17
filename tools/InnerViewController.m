//
//  InnerViewController.m
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "InnerViewController.h"
#import "PopView.h"
#import "ShopModel.h"
#import "MapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "UpMessionViewController.h"
#import "UIView+NFExtension.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ShopMession.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface InnerViewController ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation InnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    _distance = (NSInteger)[location distanceFromLocation:_shopLocation];
    _userLocation = location;
    _popView.distance.text = [NSString stringWithFormat:@"距离：%ldm",_distance];

    
}

- (void)setupContent{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor =[UIColor colorWithRed:0.8548 green:0.8548 blue:0.8548 alpha:1.0];
    _scrollView.contentSize = CGSizeMake(0, kScreenHeight);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.8548 green:0.8548 blue:0.8548 alpha:1.0];
    _popView = [[[NSBundle mainBundle] loadNibNamed:@"PopView" owner:nil options:nil] lastObject];
    _popView.frame = CGRectMake(0, 0, kScreenWidth, 95);
    _popView.model = self.model;
    [_scrollView addSubview:_popView];
    
    
    UIButton *showMapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showMapButton.layer.borderColor = [UIColor grayColor].CGColor;
    showMapButton.layer.borderWidth = 0.5;
    showMapButton.frame = CGRectMake(0, CGRectGetMaxY(_popView.frame), kScreenWidth, 40);
    [showMapButton setTitle:@"查看地图位置" forState:UIControlStateNormal];
    [showMapButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    showMapButton.backgroundColor = [UIColor whiteColor];
    [showMapButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:showMapButton];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, 174+10-64+20 , kScreenWidth - 24, 40)];
    lable.text = @"是否找到了门店？";
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = [UIColor grayColor];
    [_scrollView addSubview:lable];
    
    NSArray *titles = @[@"找到了（定位准确）",@"找到了（定位出错）",@"纠错：找不到"];
    
    CGFloat btnW = kScreenWidth - 24;
    CGFloat btnH = 44;
    for (int i=0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12, 174 + 10 + 40 -64 + 20+ (btnH + 20)*i, btnW, btnH);
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside
         ];
        button.tag = 100 + i;
        [_scrollView addSubview:button];
    }
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 410 - 64 + 20 + 10, kScreenWidth-24, 100)];
    textView.text = @"友情提示：\n1、室内门店，指门店的所在地址在大厦或商场等楼宇内部。\n2、室外门店，指门店的所在地址在街边，不在大厦或商场内。";
    textView.backgroundColor =[UIColor colorWithRed:0.8548 green:0.8548 blue:0.8548 alpha:1.0];
    textView.textColor = [UIColor grayColor];
    textView.font = [UIFont systemFontOfSize:14];
    textView.userInteractionEnabled = NO;
    [_scrollView addSubview:textView];
}

- (void)showMap{
    MapViewController *mapVc = [[MapViewController alloc] init];
    mapVc.model = self.model;
    [self.navigationController pushViewController:mapVc animated:YES];
}

- (void)buttonClick:(UIButton *)button{
    ShopMession *shopMession = [[ShopMession alloc] init];
    shopMession.shopId = self.model.shopid;
    shopMession.shopName = self.model.name;
    CLLocation *shopLocation = [[CLLocation alloc] init];
    shopLocation = self.shopLocation;
    
    UpMessionViewController *upMessionVC = [[UpMessionViewController alloc] init];
    upMessionVC.shopMession = shopMession;
    upMessionVC.shopLocation = shopLocation;
    
    if (button.tag == 100) {
        upMessionVC.wrongType = @"定位准确";
        [self.navigationController pushViewController:upMessionVC animated:YES];
        
    }else if (button.tag == 101){
        upMessionVC.wrongType = @"定位出错";
        [self.navigationController pushViewController:upMessionVC animated:YES];
        
    }else{
        if (_distance > 100) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"距离太远，请确认是否到达该店附近" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        //上传错误店家信息
        [self checkIfWrong];
    }
}

- (void)checkIfWrong{
    ShopMession *shopMession = [[ShopMession alloc] init];
    shopMession.shopId = self.model.shopid;
    shopMession.shopName = self.model.name;
    shopMession.shopType = @"不存在";
    shopMession.shopLat = [NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude];
    shopMession.shopLon = [NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude];
    shopMession.creat_time = [NSString stringWithFormat:@"%@",[self getCurrentTime]];
    shopMession.about = @"";
    UIImage *image = [UIImage imageNamed:@"place.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *outerImageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    MBProgressHUD *hud = [self.view createHUDWithTitle:@"上传中..."];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *innerImageString = @"#";
    NSString *url = @"http://app.guonongda.com:8080/st/saveshop.do";
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[shopMession.shopType dataUsingEncoding:NSUTF8StringEncoding] name:@"shopType"];
        [formData appendPartWithFormData:[shopMession.shopName dataUsingEncoding:NSUTF8StringEncoding] name:@"shopName"];
        [formData appendPartWithFormData:[shopMession.shopId dataUsingEncoding:NSUTF8StringEncoding] name:@"shopId"];
        [formData appendPartWithFormData:[shopMession.creat_time dataUsingEncoding:NSUTF8StringEncoding] name:@"creat_time"];
        [formData appendPartWithFormData:[shopMession.shopLon dataUsingEncoding:NSUTF8StringEncoding] name:@"shopLon"];
        [formData appendPartWithFormData:[shopMession.shopLat dataUsingEncoding:NSUTF8StringEncoding] name:@"shopLat"];
        [formData appendPartWithFormData:[userId dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
        [formData appendPartWithFormData:[outerImageString dataUsingEncoding:NSUTF8StringEncoding] name:@"shopOuterImages"];
        [formData appendPartWithFormData:[innerImageString dataUsingEncoding:NSUTF8StringEncoding] name:@"shopInnerImages"];
        [formData appendPartWithFormData:[shopMession.about dataUsingEncoding:NSUTF8StringEncoding] name:@"about"];
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
            hud.labelText = @"上传失败";
            [hud hide:YES afterDelay:0.3];
        }
        
    }] resume];

}

- (NSDate *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
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
