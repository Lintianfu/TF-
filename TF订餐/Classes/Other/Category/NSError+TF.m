//
//  NSError+TF.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/10.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "NSError+TF.h"



@implementation NSError (TF)
-(NSString *)dl_errorInfo
{
    if (self && self.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([self.userInfo objectForKey:@"msg"]) {
            
            tipStr = [self.userInfo objectForKey:@"msg"];
        }else{
            if ([self.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [self.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)self.code];
            }
        }
        return tipStr;
    }
    return nil;
}

@end
