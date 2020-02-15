//
//  Food.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "Food.h"
#define DLIconURL @"http://119.145.103.100:8898/meal"
#define DLIP @"http://119.145.103.100:8898"//东丽机房
#define DLPicURL [NSString stringWithFormat:@"%@/meal",DLIP]
@implementation Food
-(instancetype)initWithDict:(NSDictionary *)dict foodSelected:(Boolean)isSelectedFood
{
    self=[super init];
    if(self)
    {
        self.foodName = [dict valueForKey:@"foodName"];
        self.foodID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        self.picture = [dict valueForKey:@"pic"];
        self.sort = [dict valueForKey:@"sort"];
        self.foodUid = [NSString stringWithFormat:@"%@",[dict valueForKey:@"foodUid"]];
        self.foodPrice = [dict valueForKey:@"foodPrice"];
        self.foodIsSelected = isSelectedFood;
    }
    return self;
}
-(void)setPicture:(NSString *)picture{
    if ([picture hasPrefix:@"http"]) {
        _picture = picture;
    }else{
        _picture = [NSString stringWithFormat:@"%@%@",DLPicURL,picture];
    }
}
@end
