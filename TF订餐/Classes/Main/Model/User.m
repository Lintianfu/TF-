//
//  User.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "User.h"

@implementation User
-(void)setAvatar:(NSString *)avatar{
    if ([avatar hasPrefix:@"http"]) {
        _avatar = avatar;
    }else{
        _avatar = [NSString stringWithFormat:@"%@%@",DLIconURL,avatar];
    }
}
@end
