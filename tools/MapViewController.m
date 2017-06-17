//
//  MapViewController.m
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface MapViewController ()<MAMapViewDelegate,AMapNaviDriveManagerDelegate,AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocation *shopLocation;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) CLLocation *userLocation;
//polylines
@property (nonatomic, strong) NSMutableArray *lines;

@end

@implementation MapViewController


- (NSMutableArray *)lines{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (void)initDriveManager{
    if (self.driveManager == nil) {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        self.driveManager.delegate = self;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

- (void)setupContent{
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    [self.view addSubview:_mapView];
    
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([_model.lat doubleValue], [_model.lon doubleValue]);
     [_mapView addAnnotation:point];
    
    _shopLocation = [[CLLocation alloc] initWithLatitude:[_model.lat doubleValue] longitude:[_model.lon doubleValue]];
    // 设置地图的跨度
    MACoordinateSpan span = MACoordinateSpanMake(0.031725, 0.020614);
    MACoordinateRegion  region = MACoordinateRegionMake(point.coordinate, span);
    [_mapView setRegion:region animated:YES];
    [_mapView setCenterCoordinate:point.coordinate animated:YES];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, kScreenHeight - 80, 80, 40);
    [button setTitle:@"到这里去" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.4964 green:0.4137 blue:1.0 alpha:1.0];
    [button addTarget:self action:@selector(routeCaculateDrive:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
   
}

//路径规划驾车
- (void)routeCaculateDrive:(UIButton *)button{
    button.enabled = NO;
    [_mapView setCenterCoordinate:_userLocation.coordinate animated:YES];
    AMapDrivingRouteSearchRequest *drivingRequest = [[AMapDrivingRouteSearchRequest alloc] init];
    drivingRequest.origin = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    drivingRequest.destination = [AMapGeoPoint locationWithLatitude:_shopLocation.coordinate.latitude longitude:_shopLocation.coordinate.longitude];
    drivingRequest.strategy = 2;//距离优先
    drivingRequest.requireExtension = YES;
    [_search AMapDrivingRouteSearch:drivingRequest];

}
- (void)routeCaculateWalk{
    AMapWalkingRouteSearchRequest *walkRequest = [[AMapWalkingRouteSearchRequest alloc] init];
    walkRequest.origin = [AMapGeoPoint locationWithLatitude:_userLocation.coordinate.latitude longitude:_userLocation.coordinate.longitude];
    walkRequest.destination = [AMapGeoPoint locationWithLatitude:_shopLocation.coordinate.latitude longitude:_shopLocation.coordinate.longitude];
    [_search AMapWalkingRouteSearch:walkRequest];
}

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    if (response.route == nil) {
        return;
    }
    NSArray *paths = response.route.paths;
    AMapPath *path = [paths firstObject];
    NSArray *steps = path.steps;
    for (AMapStep *step in steps) {
//        NSLog(@"%@",step.instruction);
//        NSLog(@"%@",step.polyline);
        NSArray *array = [step.polyline componentsSeparatedByString:@";"];
        for (NSString *string in array) {
            [self.lines addObject:string];
        }
    }
    
     [self addlinesToMap];
}
- (void)addlinesToMap{
    CLLocationCoordinate2D commonPolylineCoords[_lines.count];
    for (int i = 0 ; i < _lines.count; i++) {
        NSString *string = _lines[i];
        NSArray *array = [string componentsSeparatedByString:@","];
        commonPolylineCoords[i].longitude = [array[0] doubleValue];
        commonPolylineCoords[i].latitude = [array[1] doubleValue];
    }
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:_lines.count];
    [_mapView addOverlay:commonPolyline];
}
//将线段加到地图上去
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        _userLocation = userLocation.location;
    }

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
