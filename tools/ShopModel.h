//
//  ShopModel.h
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property (nonatomic, copy) NSString *shopid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, assign) NSInteger  juli;
@property (nonatomic, copy) NSString *imgurl;
@end
