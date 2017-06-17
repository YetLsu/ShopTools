//
//  ShopMession.m
//  tools
//
//  Created by guest on 16/8/24.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ShopMession.h"

@implementation ShopMession

- (instancetype)init{
    self = [super init];
    if (self) {
        _shopInnerImages = [NSMutableArray array];
        _shopOuterImages = [NSMutableArray array];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.shopId forKey:@"shopId"];
    [aCoder encodeObject:self.shopName forKey:@"shopName"];
    [aCoder encodeObject:self.shopLat forKey:@"shopLat"];
    [aCoder encodeObject:self.shopLon forKey:@"shopLon"];
    [aCoder encodeObject:self.shopType forKey:@"shopType"];
    [aCoder encodeObject:self.shopOuterImages forKey:@"shopOuterImages"];
    [aCoder encodeObject:self.shopInnerImages forKey:@"shopInnerImages"];
    [aCoder encodeObject:self.creat_time forKey:@"creat_time"];
    [aCoder encodeObject:self.about forKey:@"about"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.shopId = [aDecoder decodeObjectForKey:@"shopId"];
        self.shopName = [aDecoder decodeObjectForKey:@"shopName"];
        self.shopLat = [aDecoder decodeObjectForKey:@"shopLat"];
        self.shopLon = [aDecoder decodeObjectForKey:@"shopLon"];
        self.shopType = [aDecoder decodeObjectForKey:@"shopType"];
        self.shopOuterImages = [aDecoder decodeObjectForKey:@"shopOuterImages"];
        self.shopInnerImages = [aDecoder decodeObjectForKey:@"shopInnerImages"];
        self.creat_time = [aDecoder decodeObjectForKey:@"creat_time"];
        self.about = [aDecoder decodeObjectForKey:@"about"];
    }
    return self;
}







@end
