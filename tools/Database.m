//
//  Database.m
//  tools
//
//  Created by guest on 16/8/10.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "Database.h"
#import "FMDB.h"

#import "ShopMession.h"
@interface Database ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation Database

- (instancetype)init{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shop.db"];
    
    _db = [FMDatabase databaseWithPath:path];
    BOOL result = [_db open];
    if (!result) {
        NSLog(@"数据库打开失败！");
        return self;
    }
    
    result = [_db executeUpdate:@"create table if not exists t_shop1(id integer primary key autoincrement,shopId text,shopName text,data blob NOT NULL)"];
    if (!result) {
        NSLog(@"建表失败");
        [_db close];
        return self;
    }
    return self;
}

+ (instancetype)database{
    static Database *database = nil;
    if (database == nil) {
        database = [[self alloc] init];
    }
    return database;
}

- (BOOL)addShopMession:(ShopMession *)shopMession{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shopMession];
    BOOL result = [_db executeUpdate:@"INSERT INTO t_shop1(shopId, data) VALUES (?,?)",shopMession.shopId,data];
    
    return result;
}

- (NSArray *)selectShopMessionWithShopId:(NSString *)shopId{
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_shop1 WHERE shopId = ?",shopId];
    while ([set next]) {
        NSData *data = [set objectForColumnName:@"data"];
        ShopMession *shopMession = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:shopMession];
    }
    [set close];
    return array;
}

- (NSArray *)selectAllShopMession{
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_shop1"];
    while ([set next]) {
        NSData *data = [set objectForColumnName:@"data"];
        ShopMession *shopMession = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [array addObject:shopMession];
    }
    [set close];
    return array;

}
- (void)deleteShopMessionWithId:(NSString *)shopId{
    [_db executeUpdate:@"DELETE FROM t_shop1 WHERE shopId = ?",shopId];

}


//
//- (NSArray *)selectFromDBWithId:(NSString *)shopId{
//    NSMutableArray *array = [NSMutableArray array];
//    FMResultSet *set = [_db executeQuery:@"select * from t_shop where shopId = ?",shopId];
//    while([set next]) {
//        NSData *data = [set objectForColumnName:@"data"];
//        ShopData *shopData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [array addObject:shopData];
//    }
//    return array;
//}

//- (NSArray *)selectFromDB{
//    NSMutableArray *array = [NSMutableArray array];
//    FMResultSet *set = [_db executeQuery:@"select * from t_shop"];
//    while([set next]) {
//        NSData *data = [set objectForColumnName:@"data"];
//        ShopData *shopData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [array addObject:shopData];
//    }
//    
//    [set close];
//    return array;
//
//}

- (void)deleteFromDBWithId:(NSString *)shopId{
   [_db executeUpdate:@"delete from t_shop where shopId = ?",shopId];
//    if (result) {
//        NSLog(@"删除成功");
//    }else{
//        NSLog(@"删除失败");
//    }

}





@end
