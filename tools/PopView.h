//
//  PopView.h
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface PopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (nonatomic, strong) ShopModel *model;
@end