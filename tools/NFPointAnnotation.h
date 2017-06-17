//
//  NFPointAnnotation.h
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class ShopModel;
@interface NFPointAnnotation : MAPointAnnotation
@property (nonatomic, strong) ShopModel *model;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, assign) BOOL isSaved;
@end
