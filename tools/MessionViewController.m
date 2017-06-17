//
//  MessionViewController.m
//  tools
//
//  Created by guest on 16/8/10.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "MessionViewController.h"
#import "Database.h"
#import "MessionCell.h"
#import "MBProgressHUD.h"
#import "UIView+NFExtension.h"
#import "AFNetworking.h"
#import "ShopMession.h"
#import "NFNetWorkUtils.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface MessionViewController ()<UITableViewDelegate,UITableViewDataSource,MessionCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;

//选中的cell的数组
//@property (nonatomic, strong) NSMutableArray *chooseArray;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

//@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, copy) NSString *userId;

@end


static NSString *const messionCellId = @"messionCellId";
@implementation MessionViewController

//- (NSMutableArray *)chooseArray{
//    if (_datasource == nil) {
//        _datasource = [NSMutableArray array];
//    }
//    return _datasource;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待提交任务";
    [self requestData];
    [self setupContent];
}
- (void)requestData{
    Database *database = [Database database];
    _datasource = [NSMutableArray arrayWithArray:[database selectAllShopMession]];
    _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (void)setupContent{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 95;
    [_tableView registerNib:[UINib nibWithNibName:@"MessionCell" bundle:nil] forCellReuseIdentifier:messionCellId];
    [self.view addSubview:_tableView];
    
    UIButton *commit = [UIButton buttonWithType:UIButtonTypeCustom];
    commit.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    [commit addTarget:self action:@selector(uploadMession) forControlEvents:UIControlEventTouchUpInside];
    [commit setTitle:@"提交任务" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.backgroundColor = [UIColor colorWithRed:0.1746 green:0.4382 blue:1.0 alpha:1.0];
    [self.view addSubview:commit];
}
- (void)messionCell:(MessionCell *)cell commitWithShopId:(NSString *)shopId{

    
    // 判断从数据库中的ShopMession与此时在datasource的一致
    ShopMession *shopMessionDB = (ShopMession *)[[[Database database] selectShopMessionWithShopId:shopId] lastObject];
    for (ShopMession *shopMession in _datasource) {
        if ([shopMessionDB.shopId isEqualToString:shopMession.shopId]) {
            [self uploadActionWithShopData:shopMession];
        }
    }
    
}
- (void)uploadMession{
    //串行队列
    dispatch_queue_t seialQueue = dispatch_queue_create("myThreadQueue", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("myThreadQueue2", DISPATCH_QUEUE_CONCURRENT);
    for (ShopMession *shopMession in _datasource) {
        
//        [self performSelector:@selector(uploadActionWithShopData:) withObject:shopMession afterDelay:1];
        
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
//            [self uploadActionWithShopData:shopMession];
//        });
//       dispatch_sync(seialQueue, ^{
//           [self uploadActionWithShopData:shopMession];
//       });
//       dispatch_sync(concurrentQueue, ^{
//           [self uploadActionWithShopData:shopMession];
//       });
//       dispatch_async(seialQueue, ^{
//            [self uploadActionWithShopData:shopMession];
//        });
       dispatch_async(concurrentQueue, ^{
            [self uploadActionWithShopData:shopMession];
        });
        
//        [self uploadActionWithShopData:shopMession];
//        NSLog(@"%@",[NSDate date]);
        
    }
}

- (void)uploadActionWithShopData:(ShopMession *)shopMession{
    NSLog(@"%@",[NSDate date]);
    
    NSString *url = @"http://app.guonongda.com:8080/st/saveshop.do";
    if (shopMession.about == nil) {
        shopMession.about = @"";
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"shopId"] = shopMession.shopId;
    parameters[@"shopName"] = shopMession.shopName;
    parameters[@"shopType"] = shopMession.shopType;
    parameters[@"shopLon"] = shopMession.shopLon;
    parameters[@"shopLat"] = shopMession.shopLat;
    parameters[@"creat_time"] = shopMession.creat_time;
    parameters[@"shopOuterImages"] = [shopMession.shopOuterImages componentsJoinedByString:@","];
    parameters[@"shopInnerImages"] = [shopMession.shopInnerImages componentsJoinedByString:@","];
    parameters[@"about"] = shopMession.about;
    parameters[@"userid"] = _userId;
    
    [NFNetWorkUtils postDataWithBaseURL:url parameters:parameters responseObject:^(id response) {
        if (response) {
            [_datasource removeObject:shopMession];
            [_tableView reloadData];
            [[Database database] deleteShopMessionWithId: shopMession.shopId];
            NSLog(@"succ");
        }
    }];
    

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessionCell *cell = [tableView dequeueReusableCellWithIdentifier:messionCellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.shopMession = _datasource[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShopMession *data = _datasource[indexPath.row];
        [_datasource removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
        [[Database database] deleteShopMessionWithId:data.shopId];
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
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
