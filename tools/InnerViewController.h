//
//  InnerViewController.h
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;
@class ShopModel;
@interface InnerViewController : UIViewController
@property (nonatomic, strong) ShopModel *model;
@property (nonatomic, strong) CLLocation *shopLocation;
@end
