//
//  NSString+TF.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TF)
- (BOOL)isEmpty;
- (NSString*)md5;
+ (NSString *)encrypt3DES:(NSString *)src key:(NSString *)key;
+ (NSString *)NSDataToHexString:(NSData *)data;
+ (NSData *)hexStrToNSData:(NSString *)hexStr;
+ (NSString *)decrypt3DES:(NSString *)src key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
