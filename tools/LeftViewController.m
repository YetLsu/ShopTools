//
//  LeftViewController.m
//  tools
//
//  Created by guest on 16/8/20.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "LeftViewController.h"
#import "LoginViewController.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 100, 200, 44);
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.092 green:0.0735 blue:0.3416 alpha:1.0];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click{
    NSLog(@"退出");
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userId"];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LoginViewController alloc] init];
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
