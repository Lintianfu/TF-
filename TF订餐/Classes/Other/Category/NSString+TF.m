//
//  NSString+TF.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/9.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "NSString+TF.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation NSString (TF)
/*
 * 判断字符串是否为空
 */
- (BOOL)isEmpty
{
    return ((self.length == 0) || (self == nil) || ([self isKindOfClass:[NSNull class]]) || (self.length == 0));
}

/*
 * 给字符串md5加密
 */
- (NSString*)md5
{
    const char *ptr = [self UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}
/*
 
 加密
 
 */
+ (NSString *)encrypt3DES:(NSString *)src key:(NSString *)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData* data = [src dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    return [self NSDataToHexString:myData];
}




//二进制转化为十六进制
+ (NSString *)NSDataToHexString:(NSData *)data{
    if (data == nil) {
        return nil;
    }
    
    NSMutableString* hexString = [NSMutableString string];
    const unsigned char *p = [data bytes];
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    
    return [hexString uppercaseString];
}



//十六进制字符串转化为二进制
+ (NSData *)hexStrToNSData:(NSString *)hexStr{
    NSMutableData* data = [NSMutableData data];
    for (int i = 0; i+2 <= hexStr.length; i+=2) {
        NSRange range = NSMakeRange(i, 2);
        NSString* ch = [hexStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:ch];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

/*
 
 解密
 
 */
+ (NSString *)decrypt3DES:(NSString *)src key:(NSString *)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *EncryptData = [self hexStrToNSData:src];
    plainTextBufferSize = [EncryptData length];
    vplainText = [EncryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *dataBuf = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    return [[NSString alloc] initWithData:dataBuf
                                 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]
    ;
}
@end
