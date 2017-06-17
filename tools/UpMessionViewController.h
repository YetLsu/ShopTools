//
//  UpMessionViewController.h
//  tools
//
//  Created by guest on 16/8/24.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;
@class ShopMession;
@interface UpMessionViewController : UIViewController

@property (nonatomic, copy) NSString *wrongType;
@property (nonatomic, strong) CLLocation *shopLocation;
@property (nonatomic, strong) ShopMession *shopMession;
@end
