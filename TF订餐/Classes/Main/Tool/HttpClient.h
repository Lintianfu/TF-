//
//  HttpClient.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN
//app端传输 key
#define BLMD5key   @"IAASIDuioponuYBIUNLIK123ikoIO"
// 加密 key
#define BLDESkey  @"ASDHOjhudhaos23asdihoh80"

//app端请求地址
#define DLIP @"http://119.145.103.100:8898"//东丽机房
#define BASEURL  [NSString stringWithFormat:@"%@/meal/app/index.do",DLIP]

@interface HttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient ;

/*
 *  发送get请求
 *
 *  @param url           请求地址
 *  @param params        请求参数
 *  @param success       成功回调
 *  @param failure       失败回调
 *  @param autoShowError 失败时是否显示请求失败信息
 */
- (NSURLSessionDataTask *)postWithParams:(NSDictionary *)params
                                 success:(void(^)(id responseObj))success
                                faliture:(void(^)(NSError *error))failure
                           autoShowError:(BOOL)autoShowError;
@end

NS_ASSUME_NONNULL_END
