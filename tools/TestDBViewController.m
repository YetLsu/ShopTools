//
//  TestDBViewController.m
//  tools
//
//  Created by guest on 16/8/25.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "TestDBViewController.h"
#import "Database.h"
#import "ShopMession.h"

@interface TestDBViewController ()

@end

@implementation TestDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    ShopMession *shop = [[ShopMession alloc] init];
    [shop.shopOuterImages addObject:imageString];
    shop.shopName = @"xx";
    shop.shopId = @"12314";
    shop.shopLat = @"30";
    shop.shopLon = @"120";
    shop.shopType = @"test";
    
    if ([[Database database] addShopMession:shop]) {
        [self test1];
    }
}

- (void)test1{
//    NSArray *array = [[Database database] selectAllShopMession];
    NSArray *array = [[Database database] selectShopMessionWithShopId:@"12314"];
    ShopMession *shopMession = array[0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:shopMession.shopOuterImages[0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData: imageData];
    imageView.image = image;
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview: imageView];
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
