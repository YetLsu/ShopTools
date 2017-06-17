//
//  NFNetWorkUtils.m
//  tools
//
//  Created by guest on 16/8/25.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "NFNetWorkUtils.h"
#import "AFNetworking.h"


@implementation NFNetWorkUtils

+ (void)getDataWithBaseURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseObject:(DataBlock)block{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil);
    }];
}


+ (void)postDataWithBaseURL:(NSString *)url parameters:(NSMutableDictionary *)parameters responseObject:(DataBlock)block{
    NSArray *keys = parameters.allKeys;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < keys.count; i++) {
            [formData appendPartWithFormData:[[parameters objectForKey:keys[i]] dataUsingEncoding:NSUTF8StringEncoding] name:keys[i]];
        }
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            block(nil);
        }else{
            block(responseObject);
        }
    }] resume];
}

@end
