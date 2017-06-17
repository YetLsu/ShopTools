//
//  Database.h
//  tools
//
//  Created by guest on 16/8/10.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopData;
@class ShopMession;
@interface Database : NSObject

+ (instancetype)database;

//旧的
//- (void)addShopData:(ShopData *)shopdata;
//- (NSArray *)selectFromDBWithId:(NSString *)shopId;
//- (NSArray *)selectFromDB;
//- (void)deleteFromDBWithId:(NSString *)shopId;


//最新的
- (BOOL)addShopMession:(ShopMession *)shopMession;
- (void)deleteShopMessionWithId:(NSString *)shopId;
- (NSArray *)selectShopMessionWithShopId:(NSString *)shopId;
- (NSArray *)selectAllShopMession;

@end
