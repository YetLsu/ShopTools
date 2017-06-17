//
//  LoginViewController.m
//  tools
//
//  Created by guest on 16/8/11.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "MenuViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LoginViewController ()
@property (nonatomic, strong) UITextField *userTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
    
}

- (void)setupContent{
    _userTF =[[UITextField alloc] initWithFrame:CGRectMake(40, 140, kScreenWidth - 80, 30)];
    _userTF.placeholder = @"请输入用户名";
    _userTF.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_userTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, 170, kScreenWidth - 80, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 200, kScreenWidth - 80, 30)];
    _passwordTF.placeholder = @"请输入密码";
    _passwordTF.secureTextEntry = YES;
    [self.view addSubview:_passwordTF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 230, kScreenWidth - 80, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 260, kScreenWidth - 80, 40);
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.2687 green:0.4278 blue:1.0 alpha:1.0];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)loginAction{
    NSString *url = @"http://chen.pgy198.com/index.php/app/user/loginByName";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = self.userTF.text;
    parameters[@"password"] = self.passwordTF.text;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"userId"] forKey:@"userId"];
        MenuViewController *menu = [[MenuViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = menu;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];

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
