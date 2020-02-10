//
//  HttpClient.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "HttpClient.h"
#import "NSString+TF.h"
#import "NSError+TF.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LoginViewController.h"
@implementation HttpClient
static HttpClient *_shareClient=nil;
+ (instancetype)sharedClient {  //单例模式
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareClient = [[HttpClient alloc] init];
        
    });
    return _shareClient;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.requestSerializer.timeoutInterval = 15;//请求超时时间
    }
    return self;
}

- (NSURLSessionDataTask *)postWithParams:(NSDictionary *)params success:(void (^)(id))success faliture:(void (^)(NSError *))failure autoShowError:(BOOL)autoShowError{
    
    NSDictionary *p = [HttpClient encodekey:BLMD5key parameters:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/json",
                                                                              @"text/html",
                                                                              nil];
    return [[HttpClient sharedClient] POST:BASEURL parameters:p progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        id error = [self handleResponse:JSON autoShowError:autoShowError];
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            
            if (success) {
                success(JSON);
            }
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (autoShowError && error) {
            
            [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
        }
        if (failure) {
            failure(error);
        }
    }];
    
}


-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //code为非0值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"error"];
    
    if (resultCode && resultCode.intValue != -1) {
        error = [NSError errorWithDomain:BASEURL code:resultCode.intValue userInfo:responseJSON];
        if (autoShowError) {
            [SVProgressHUD showErrorWithStatus:[error dl_errorInfo]];
        }
    }
    
    if (error.code == -2) {//太久未登录，转跳到登录界面
        [UIApplication sharedApplication].windows[0].rootViewController = [[LoginViewController alloc] init];
    }
    return error;
}



/**
 * 构建通用网关的请求 url，参数为键值对形式，不分顺序。不需要包含时间戳、签名等参数 ，系统会自动增加。
 *
 * @param key
 *                  加密的key
 * @param parameters
 *                  参数
 * @return  生成后的网关
 */
+ (NSDictionary *) encodekey:(NSString *)key parameters:(NSDictionary  *)parameters
{
    
    if ([[parameters allKeys] containsObject:@"_s"] || [[parameters allKeys] containsObject:@"_t"]){
        NSLog(@"在使用 ShoveGeneralRestGateway buildUrl 方法构建通用 REST 接口 Url 时，不能使用 _s, _t 此保留字作为参数名。");
        return nil;
    }
    
    if ([key isEmpty]) {
        NSLog(@"在使用 ShoveGeneralRestGateway buildUrl 方法构建通用 REST 接口 Url 时，必须提供一个用于摘要签名用的 key (俗称 MD5 加盐)。");
        return nil;
    }
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    NSString* currentDate = [formatter stringFromDate:date];
    [parameters setValue:currentDate forKey:@"_t"];
    
    
    
    NSArray *parameterNames = [parameters allKeys];
    parameterNames = [parameterNames sortedArrayUsingSelector:@selector(compare:)];// 字符串编码升序排序
    
    NSString *signData = @"";
    
    for (int i = 0; i < [parameters count]; i++) {
        NSString *_key = parameterNames[i];
        NSString * _value = parameters[_key];
        
        signData = [NSString stringWithFormat:@"%@%@=%@", signData, _key, _value];
        //[parameters setValue:[_value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:_key];// 将中文等特殊字符编码
        if (i < ([parameters count] - 1)) {
            signData = [signData stringByAppendingString:@"&"];
        }
    }
    [parameters setValue:[[signData stringByAppendingString:key] md5] forKey:@"_s"];
    return parameters;
}


@end
