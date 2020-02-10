//
//  User.h
//  TF订餐
//
//  Created by Mr.TF on 2020/2/7.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DLIconURL @"http://119.145.103.100:8898/meal"
NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *avatar;
-(void)setAvatar:(NSString *)avatar;
@end

NS_ASSUME_NONNULL_END
