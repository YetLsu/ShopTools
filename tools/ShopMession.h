//
//  ShopMession.h
//  tools
//
//  Created by guest on 16/8/24.
//  Copyright © 2016年 聂凡. All rights reserved.

#import <Foundation/Foundation.h>

@interface ShopMession : NSObject<NSCoding>
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
//店的图片
@property (nonatomic, strong) NSMutableArray *shopOuterImages;
@property (nonatomic, strong) NSMutableArray *shopInnerImages;
//错误类型
@property (nonatomic, copy) NSString *shopType;
//店的地理位置
@property (nonatomic, copy) NSString *shopLat;
@property (nonatomic, copy) NSString *shopLon;
//拍照的时间
@property (nonatomic, copy) NSString *creat_time;
//备注
@property (nonatomic, copy) NSString *about;

@end
