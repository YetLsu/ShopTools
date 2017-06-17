//
//  SummitMessionViewController.m
//  tools
//
//  Created by guest on 16/8/20.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "SummitMessionViewController.h"
#import "AFNetworking.h"
#import "SubmitShopModel.h"
#import "MJExtension.h"
#import "SubmitCell.h"
@interface SummitMessionViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;

@end


static NSString *const submitCellIdentifier = @"submitCellIdentifier";
@implementation SummitMessionViewController


- (NSMutableArray *)datasource{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    [self setupContent];
}

- (void)requestData{
    
    NSString *url = @"http://app.guonongda.com:8080/st/getData.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *data = responseObject[@"data"];
        for (NSDictionary *dict in data) {
            SubmitShopModel *shopModel = [[SubmitShopModel alloc] init];
            shopModel.shopId = dict[@"shopId"];
            shopModel.shopType = dict[@"shopType"];
            shopModel.shopName = dict[@"shopName"];
            shopModel.creat_time = dict[@"creat_time"];
            shopModel.shopOutImages = dict[@"shopOuterImages"];
            [self.datasource addObject:shopModel];
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"error %@",error);
        }
    }];
    
    
}

- (void)setupContent{
    [self.tableView registerNib:[UINib nibWithNibName:@"SubmitCell" bundle:nil] forCellReuseIdentifier:submitCellIdentifier];
    self.tableView.rowHeight = 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:submitCellIdentifier forIndexPath:indexPath];
    cell.model = _datasource[indexPath.row];
    return cell;

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
