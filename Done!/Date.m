//
//  NYDate.m
//  Done!
//
//  Created by Yongyang Nie on 6/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "Date.h"

@implementation Date

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultDateFormatter = [NSDateFormatter new];
        [_defaultDateFormatter setDateStyle:NSDateFormatterFullStyle];
        [_defaultDateFormatter setTimeStyle:NSDateFormatterFullStyle];
        _defaultDateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
    }
    return self;
}

+(NSDate *)todayStarts{

    NSDate *date = [NSDate date];
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&date interval:NULL forDate:[NSDate date]];
    return date;
}
+(NSDate *)tomorrowStarts{
    
    NSDate *date = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate: [Date todayStarts]];
    return date;
}

+(NSDateFormatter *)getDefaultDateFormatter{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
    return dateFormatter;
}

+(NSDate *)getDateTodayWithHour:(NSUInteger)hour minutes:(NSUInteger)minutes{
    
    NSDate *dateInUTC = [[NSDate alloc] init];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *today = [dateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *dayComponents = [gregorian components:(NSCalendarUnitDay) fromDate:today];
    [dayComponents setHour:hour];
    [dayComponents setMinute:minutes];
    [dayComponents setTimeZone:[NSTimeZone localTimeZone]];
    today = [gregorian dateFromComponents:dayComponents];
    
    return today;
}

@end
