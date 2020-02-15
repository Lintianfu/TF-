//
//  NSDate+TF.m
//  TF订餐
//
//  Created by Mr.TF on 2020/2/14.
//  Copyright © 2020 Mr.TF. All rights reserved.
//

#import "NSDate+TF.h"
@implementation NSDate (TF)
+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday,*afterToday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    afterToday = [today dateByAddingTimeInterval: secondsPerDay*2];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *afterTodayString = [[afterToday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return [NSString stringWithFormat:@"%@(今天)",dateString];
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return [NSString stringWithFormat:@"%@(昨天)",dateString];
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return [NSString stringWithFormat:@"%@(明天)",dateString];
    }else if ([dateString isEqualToString:afterTodayString]){
        return [NSString stringWithFormat:@"%@(后天)",dateString];
    }
    else
    {
        return dateString;
    }
}
@end
