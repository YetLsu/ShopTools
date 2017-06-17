//
//  ShowImageViewController.m
//  tools
//
//  Created by guest on 16/8/26.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ShowImageViewController.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ShowImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil options:SDWebImageRetryFailed];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)dismiss:(UITapGestureRecognizer *)tap{

    [self dismissViewControllerAnimated:YES completion:nil];
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
