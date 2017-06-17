//
//  UIView+NFExtension.h
//  tools
//
//  Created by guest on 16/8/17.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface UIView (NFExtension)
- (MBProgressHUD *)createHUD;
- (MBProgressHUD *)createHUDWithTitle:(NSString *)title;
- (MBProgressHUD *)createDimBackgroundHUD;
- (MBProgressHUD *)createDimBackgroundHUDWithTitle:(NSString *)title;

- (UIViewController *)getControllerFromFirstView:(UIView *)firstView;

@end
