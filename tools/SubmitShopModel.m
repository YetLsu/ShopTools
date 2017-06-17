//
//  SubmitShopModel.m
//  tools
//
//  Created by guest on 16/8/20.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "SubmitShopModel.h"

@implementation SubmitShopModel


- (void)setCreat_time:(NSString *)creat_time{
    if (_creat_time != creat_time) {
        _creat_time = [creat_time substringToIndex:19];
    }
}

@end
