//
//  ViewController.m
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ShopModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "NFPointAnnotation.h"
#import "PopView.h"
#import "InnerViewController.h"
#import "Database.h"
#import "ShopMession.h"
#import "MessionViewController.h"
#import "ShopsViewController.h"
#import "SummitMessionViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "NFNetWorkUtils.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kMainShopURL @"http://app.guonongda.com:8080/shop/nearbyshop.do"
@interface ViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) PopView *popView;
@property (nonatomic, strong) CLLocation *shopLocation;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, assign) BOOL isLeftViewShow;
//新店的大头针模型
@property (nonatomic, strong) NSMutableArray *findNewAnnotations;
@end

@implementation ViewController


- (NSMutableArray *)findNewAnnotations{
    if (_findNewAnnotations == nil) {
        _findNewAnnotations = [NSMutableArray array];
    }
    return _findNewAnnotations;
}

- (NSMutableArray *)annotations{
    if (_annotations == nil) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}
- (void)viewWillAppear:(BOOL)animated{
    _popView.hidden = YES;
    if (_annotations.count != 0) {
        [self removePointAnnotation];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMapView];
    
    [self setContentView];
    
    [self setupNavigation];
    
}

- (void)leftViewShowOrHide{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)setupNavigation{
    
    UIButton *findMe = [UIButton buttonWithType:UIButtonTypeCustom];
    findMe.frame = CGRectMake(0, 0, 60, 40);
    [findMe setTitle:@"我" forState:UIControlStateNormal];
    [findMe setTitleColor:[UIColor colorWithRed:0.2449 green:0.3357 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [findMe addTarget:self action:@selector(leftViewShowOrHide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:findMe];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:@"附近" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.2449 green:0.3357 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showShops) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)showShops{
    ShopsViewController *shopsVc = [[ShopsViewController alloc] init];
    shopsVc.userLocation = self.userLocation;
    [self.navigationController pushViewController:shopsVc animated:YES];

}

- (void)setupMapView{
    [AMapServices sharedServices].apiKey = @"8801d09ce86dabcf779854e8e99f62c9";
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    _mapView.rotateCameraEnabled = NO;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    [self.view addSubview:_mapView];
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{

    if (_popView.hidden == NO) {
        _popView.hidden = YES;
    }
}


- (void)setContentView{
    _popView = [[[NSBundle mainBundle] loadNibNamed:@"PopView" owner:nil options:nil] lastObject];
    _popView.frame = CGRectMake(12, 64, kScreenWidth-24, 95);
    _popView.hidden = YES;
    _popView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_popView addGestureRecognizer:tap];
    [self.view addSubview:_popView];
    
    UIButton *findMe = [UIButton buttonWithType:UIButtonTypeCustom];
    findMe.frame = CGRectMake(0, kScreenHeight - 80, 30, 30);
    [findMe setTitle:@"我" forState:UIControlStateNormal];
    [findMe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    findMe.backgroundColor = [UIColor colorWithRed:0.1746 green:0.4382 blue:1.0 alpha:1.0];
    [findMe addTarget:self action:@selector(findMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findMe];
    
    UIButton *mession = [UIButton buttonWithType:UIButtonTypeCustom];
    [mession setTitle:@"待提交任务" forState:UIControlStateNormal];
    [mession setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mession.backgroundColor = [UIColor colorWithRed:0.1746 green:0.4382 blue:1.0 alpha:1.0];
    mession.frame = CGRectMake(12, kScreenHeight - 40, (kScreenWidth-3*12)/2, 40);
    [mession addTarget:self action:@selector(messionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mession];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"已提交任务" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.1746 green:0.4382 blue:1.0 alpha:1.0];
    button.frame = CGRectMake((kScreenWidth-3*12)/2 +24, kScreenHeight - 40, (kScreenWidth-3*12)/2, 40);
    [button addTarget:self action:@selector(showMyMession:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)showMyMession:(UIButton *)button{
    SummitMessionViewController *submitVc = [[SummitMessionViewController alloc] init];
    [self.navigationController pushViewController:submitVc animated:YES];
}

- (void)messionAction{
    MessionViewController *messionVc = [[MessionViewController alloc] init];
    [self.navigationController pushViewController:messionVc animated:YES];
}


- (void)tapAction{
    InnerViewController *innerVc = [[InnerViewController alloc] init];
    innerVc.model = _popView.model;
    innerVc.shopLocation = _shopLocation;
    [self.navigationController pushViewController:innerVc animated:YES];
}



- (void)findShop{
    if (_annotations.count != 0) {
        [_mapView removeAnnotations:_annotations];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *url = @"http://app.guonongda.com:8080/shop/nearbyshop.do";
    parameters[@"lat"] = @(_userLocation.coordinate.latitude);
    parameters[@"lon"] = @(_userLocation.coordinate.longitude);
    [NFNetWorkUtils getDataWithBaseURL:url parameters:parameters responseObject:^(id response) {
        if (response != nil) {
            NSArray *data = response[@"data"];
            for (NSDictionary *dict in data) {
                
                ShopModel *model = [ShopModel mj_objectWithKeyValues:dict];
                NFPointAnnotation *point = [[NFPointAnnotation alloc] init];
                point.model = model;
                point.shopId = model.shopid;
                point.coordinate = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lon"] doubleValue]);
                point.title = dict[@"name"];
                point.subtitle = dict[@"address"];
                [_mapView addAnnotation:point];
                [self.annotations addObject:point];
                
            }
            [self removePointAnnotation];
        }else{
            NSLog(@"请求失败！");
        }
    }];
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass:[MAPinAnnotationView class]]) {
        _popView.hidden = NO;
        NFPointAnnotation *pointAnnotation =(NFPointAnnotation *)view.annotation;
        ShopModel *model = pointAnnotation.model;
        _popView.model = model;
        _shopLocation = [[CLLocation alloc] initWithLatitude:[model.lat doubleValue] longitude: [model.lon doubleValue]];
    }else
        return;
}

- (void)removePointAnnotation{
    NSArray *array = [[Database database] selectAllShopMession];
    for (ShopMession *data in array) {
        NSString *shopId = data.shopId;
        [self removeAnnotationWith:shopId];
        
//        if ([data.shopType isEqualToString:@"新店"] ) {
//            
//            [self addNewShopAnnotation:data];
//        }
    }
}
#warning TODO
//添加新发现的店的大头针
- (void)addNewShopAnnotation:(ShopMession *)data{
    NFPointAnnotation *pointAnnotation = [[NFPointAnnotation alloc] init];
    pointAnnotation.shopId = data.shopId;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([data.shopLat doubleValue], [data.shopLon doubleValue]);
    pointAnnotation.isSaved = YES;
//    [self.findNewAnnotations addObject:pointAnnotation];
    [_mapView addAnnotation:pointAnnotation];
}


//替换大头针颜色
- (void)removeAnnotationWith:(NSString *)shopId{
    for (NFPointAnnotation *annotation in _annotations) {
        if (annotation.shopId == shopId && annotation.isSaved != YES) {
            annotation.isSaved = YES;
            [_mapView removeAnnotation:annotation];
            [_mapView addAnnotation:annotation];
        }
    }
}

- (void)findMe{
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        _userLocation = userLocation.location;
        
        if (_shopLocation != nil) {
            
            _distance = (NSInteger)[_userLocation distanceFromLocation:_shopLocation];
            _popView.distance.text = [NSString stringWithFormat:@"距离：%ldm",_distance];
        }
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //0.031725,0.020614
            [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
            MACoordinateSpan span = MACoordinateSpanMake(0.031725, 0.020614);
            MACoordinateRegion  region = MACoordinateRegionMake(_userLocation.coordinate, span);
            [_mapView setRegion:region animated:YES];
            [self findShop];
            
            //构造圆
//            MACircle *circle = [MACircle circleWithCenterCoordinate:_userLocation.coordinate radius:3000];
            
            //在地图上添加圆
//            [_mapView addOverlay: circle];
            
        });
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if (![annotation isKindOfClass:[NFPointAnnotation class]]) {
        NSLog(@"%@",[annotation class]);
    }
    
    if ([annotation isKindOfClass:[NFPointAnnotation class]]) {
        NFPointAnnotation *annotationNF = (NFPointAnnotation *)annotation;
        static NSString *reusedIdentifier = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: reusedIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotationNF reuseIdentifier:reusedIdentifier];
        }
        if (annotationNF.isSaved) {
            annotationView.pinColor = MAPinAnnotationColorGreen;
        }else {
            annotationView.pinColor = MAPinAnnotationColorPurple;
        }
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{

//    if ([overlay isKindOfClass:[MACircle class]])
//    {
//        
//        MACircleRenderer *circleView = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];
//        
//        circleView.lineWidth = 5.f;
//        circleView.strokeColor = [UIColor colorWithRed:0.5465 green:1.0 blue:0.5052 alpha:1.0];
//        circleView.fillColor = [UIColor clearColor];
//        circleView.lineDash = YES;//YES表示虚线绘制，NO表示实线绘制
//        
//        return circleView;
//    }
//    return nil;
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
