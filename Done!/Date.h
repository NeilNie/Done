//
//  NYDate.h
//  Done!
//
//  Created by Yongyang Nie on 6/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface Date : NSDate

@property (strong, nonatomic) NSDateFormatter *defaultDateFormatter;

+(NSDate *)todayStarts;
+(NSDate *)tomorrowStarts;

+(NSDateFormatter *)getDefaultDateFormatter;
+(NSDate *)getDateTodayWithHour:(NSUInteger)hour minutes:(NSUInteger)minutes;

@end
