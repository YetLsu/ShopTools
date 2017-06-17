//
//  ShopsViewController.m
//  tools
//
//  Created by guest on 16/8/13.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ShopsViewController.h"
#import "ShopsCell.h"
#import "MJExtension.h"
#import "ShopModel.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "InnerViewController.h"
#import "UpMessionViewController.h"
#import "NFNetWorkUtils.h"
#define kShopURL @"http://app.guonongda.com:8080/shop/nearbyshop.do"
@interface ShopsViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

static NSString *const shopsCellIdentifier = @"shopsCellIdentifier";
@implementation ShopsViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupTableView];
    
    [self requestData];
}

- (void)setupNavigation{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 0, 50, 40);
    [button addTarget:self action:@selector(newShop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;

}
-(void)newShop{
    UpMessionViewController *upMessionVC = [[UpMessionViewController alloc] init];
    upMessionVC.wrongType = @"新店";
    [self.navigationController pushViewController:upMessionVC animated:YES];
    
}

- (void)requestData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *url = @"http://app.guonongda.com:8080/shop/nearbyshop.do";
    parameters[@"lat"] = @(_userLocation.coordinate.latitude);
    parameters[@"lon"] = @(_userLocation.coordinate.longitude);
    
    [NFNetWorkUtils getDataWithBaseURL:url parameters:parameters responseObject:^(id response) {
        if (response) {
            NSArray *data = response[@"data"];
            for (NSDictionary *dict in data) {
                ShopModel *model = [ShopModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"shibai");
            
        }
    }];
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *data = responseObject[@"data"];
//        for (NSDictionary *dict in data) {
//            ShopModel *model = [ShopModel mj_objectWithKeyValues:dict];
//            [self.dataSource addObject:model];
//        }
//        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        
//    }];
    

}


- (void)setupTableView{
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopsCell" bundle:nil] forCellReuseIdentifier:shopsCellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopsCell *cell = [tableView dequeueReusableCellWithIdentifier:shopsCellIdentifier forIndexPath:indexPath];
    cell.shopModel = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopModel *model = _dataSource[indexPath.row];
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[model.lat doubleValue] longitude:[model.lon doubleValue]];
    InnerViewController *innerVc = [[InnerViewController alloc] init];
    innerVc.shopLocation = shopLocation;
    innerVc.model = model;
    [self.navigationController pushViewController:innerVc animated:YES];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
