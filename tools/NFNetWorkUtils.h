//
//  NFNetWorkUtils.h
//  tools
//
//  Created by guest on 16/8/25.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataBlock)(id response);
@interface NFNetWorkUtils : NSObject

//GET请求
+ (void)getDataWithBaseURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseObject:(DataBlock)block;

//POST表单提交
+ (void)postDataWithBaseURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseObject:(DataBlock)block;



@end
