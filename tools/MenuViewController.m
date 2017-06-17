//
//  MenuViewController.m
//  tools
//
//  Created by guest on 16/8/20.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "LeftViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.leftDrawerViewController = [[LeftViewController alloc] init];
    
    
    ViewController *viewController = [[ViewController alloc] init];
    self.centerViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.maximumLeftDrawerWidth = kScreenWidth * 0.7;
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningNavigationBar;
    self.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.showsShadow = NO;
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
