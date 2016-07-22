//
//  EventsHelper.m
//  Done!
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "EventsHelper.h"

@implementation EventsHelper

+(Events *)createEventWithDate:(NSDate *)date title:(NSString *)title otherInfo:(NSDictionary *)info{
    
    Events *NewEvent = [[Events alloc] init];
    NewEvent.title = title;
    NewEvent.date = date;
    NewEvent.completed = NO;
    NewEvent.important = NO;
    NewEvent.uoid = [self uoid];
    return NewEvent;
}

+ (NSString *)uoid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

+(NSDate *)currentDateLocalTimeZone{
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    return destinationDate;
}

+(Projects *)createProjectWithDate:(NSDate *)date title:(NSString *)title{
    
    Projects *NewProject = [[Projects alloc] init];
    NewProject.title = title;
    NewProject.date = date;
    return NewProject;
}
+(void)deleteEvent:(Events *)event{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:event];
    [realm commitWriteTransaction];
}
+(void)modifyEventValue:(NSString *)value withKey:(NSString *)key{
    
}
+(NSMutableArray *)convertToArray:(RLMArray *)results{
    
    NSMutableArray *arry = [NSMutableArray array];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    for (int i = 0; i < results.count; i++) {
        
        Events *event = [results objectAtIndex:i];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:event.title forKey:@"title"];
        [dictionary setValue:[formate stringFromDate:event.date] forKey:@"date"];
        [dictionary setValue:[NSNumber numberWithBool:event.completed] forKey:@"completed"];
        [dictionary setValue:[NSNumber numberWithBool:event.important] forKey:@"important"];
        [arry addObject:dictionary];
    }
    return arry;
}
+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy hh:mm";
    }
    
    return dateFormatter;
}

+(NSMutableArray *)convertEventsToArray:(RLMResults *)results{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < results.count; i++) {
        
        Events *event = [results objectAtIndex:i];
        [array addObject:event];
    }
    return array;
}

+(NSMutableArray *)convertAllObjecttoArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    RLMResults *result = [Projects allObjects];
    
    for (int i = 0; i < result.count; i++) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        Projects *pro = [result objectAtIndex:i];
        [dic setValue:pro.title forKey:@"title"];
        [dic setValue:pro.date forKey:@"date"];
        
        NSMutableArray *es = [[NSMutableArray alloc] init];
        for (int i = 0; i < pro.events.count; i ++) {
            Events *e = [pro.events objectAtIndex:i];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:e.title forKey:@"title"];
            [dic setValue:e.date forKey:@"date"];
            [dic setValue:[NSNumber numberWithBool:e.completed] forKey:@"completed"];
            [dic setValue:[NSNumber numberWithBool:e.important] forKey:@"important"];
            [es addObject:dic];
        }
        [dic setValue:es forKey:@"events"];
        
        [array addObject:dic];
    }
    return array;
}

+(void)createRealmWithArray:(NSMutableArray *)array{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dic = [array objectAtIndex:i];
        [realm beginWriteTransaction];
        Projects *pro = [[Projects alloc] init];
        pro.title = [dic objectForKey:@"title"];
        pro.date = [dic objectForKey:@"date"];
       
        NSArray *es = [dic objectForKey:@"events"];
        for (int i = 0; i < es.count; i++) {
            NSDictionary *d = [es objectAtIndex:i];
            Events *e = [[Events alloc] init];
            e.title = [d objectForKey:@"title"];
            e.date = [d objectForKey:@"date"];
            e.completed = ([[d objectForKey:@"completed"] intValue] == 1)? YES : NO;
            e.important = ([[d objectForKey:@"important"] intValue] == 1)? YES : NO;
            [pro.events addObject:e];
        }
        [realm addObject:pro];
        NSLog(@"added event %@", pro);
        [realm commitWriteTransaction];
    }
}

+(NSMutableArray *)findEventsForToday:(NSDate *)today withRealm:(RLMResults *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy"];
    
    for (int i = 0; i < realm.count; i++) {
        
        Events *event = [realm objectAtIndex:i];
        if ([[formate stringFromDate:today] isEqualToString:[formate stringFromDate:event.date]]) {
            [array addObject:event];
        }
    }
    return array;
}

+(NSMutableArray *)findEventsForToday:(NSDate *)today withArrayOfEvents:(NSMutableArray *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy"];
    
    for (int i = 0; i < realm.count; i++) {
        
        Events *event = [realm objectAtIndex:i];
        if ([[formate stringFromDate:today] isEqualToString:[formate stringFromDate:event.date]]) {
            [array addObject:event];
        }
    }
    return array;
}
 
+(NSMutableArray *)findTodayCompletedEvents:(RLMArray *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == YES) {
            [array addObject:event];
        }
    }
    return array;
}

+(NSMutableArray *)findTodayNotCompletedEvents:(RLMResults *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *objects = [self findEventsForToday:[EventsHelper currentDateLocalTimeZone] withRealm:realm];
    
    for (int i = 0; i < objects.count; i ++) {
        
        Events *event = [objects objectAtIndex:i];
        if (event.completed == NO) {
            [array addObject:event];
        }
    }
    return array;
}

+(NSMutableArray *)findCompletedEventsWithArrayOfEvents:(NSMutableArray *)realm withDate:(NSDate *)date{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy"];

    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == YES && [[formate stringFromDate:date] isEqualToString:[formate stringFromDate:event.date]]) {
            [array addObject:event];
        }
    }
    return array;
}

+(NSMutableArray *)findCompletedEventsRealm:(RLMResults *)realm withDate:(NSDate *)date{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateStyle:NSDateFormatterShortStyle];
    [formate setTimeZone:[NSTimeZone localTimeZone]];
    
    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == YES) {
            if ([[formate stringFromDate:date] isEqualToString:[formate stringFromDate:event.date]]) {
                [array addObject:event];
            }
        }
    }
    return array;
}

+(Events *)findEarliestEventTodayWithArray:(NSMutableArray *)array{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH"];
    Events *event = [array firstObject];
    for (int i = 0; i < array.count; i++) {
        Events *e = [array objectAtIndex:i];
        if ([formate stringFromDate:e.date].intValue < [formate stringFromDate:event.date].intValue) {
            event = e;
        }
        
    }
    return event;
}

+(Events *)findEventWithTitle:(NSString *)string withAllRealm:(RLMResults *)array{
    
    Events *event = [[Events alloc] init];
    for (int i = 0; i < array.count; i++) {
        
        Events *e = [array objectAtIndex:i];
        if ([e.title isEqualToString:string]) {
            return e;
        }
    }
    return event;
}

+(Events *)findMostRecentEvent:(NSDate *)date withArrayOfEvents:(NSMutableArray *)realm{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH"];
    
    //create event
    Events *returnEvent = [realm firstObject];
    //get the difference between time now and first event of the day.
    int diff = [formate stringFromDate:returnEvent.date].intValue - [formate stringFromDate:date].intValue;
    
    //run a loop through
    for (int i = 0; i < realm.count; i++) {
        Events *e = [realm objectAtIndex:i];
        
        //see of the difference in time of the current event and current date
        int Cdiff = [formate stringFromDate:e.date].intValue - [formate stringFromDate:date].intValue;
        
        //if Cdiff is positive and larger than diff, then the returnEvent is that object. 
        if (Cdiff > 0 && Cdiff < diff) {
            returnEvent = e;
        }
        
    }
    return returnEvent;
}

+(NSMutableArray *)findNotCompletedEvents:(RLMArray *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == NO) {
            [array addObject:event];
        }
    }
    return array;
}

+(Events *)findMostRecentEvent:(NSDate *)date withRealm:(RLMArray *)realm{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH"];
    
    //create event
    Events *returnEvent = [realm firstObject];
    //get the difference between time now and first event of the day.
    int diff = [formate stringFromDate:returnEvent.date].intValue - [formate stringFromDate:date].intValue;
    
    //run a loop through
    for (int i = 0; i < realm.count; i++) {
        Events *e = [realm objectAtIndex:i];
        
        //see of the difference in time of the current event and current date
        int Cdiff = [formate stringFromDate:e.date].intValue - [formate stringFromDate:date].intValue;
        
        //if Cdiff is positive and larger than diff, then the returnEvent is that object.
        if (Cdiff > 0 && Cdiff < diff) {
            returnEvent = e;
        }
        
    }
    return returnEvent;
}

+(Events *)findMostRecentEvent:(NSDate *)date withRealmResult:(RLMResults *)realm{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"HH"];
    
    //create event
    Events *returnEvent = [realm firstObject];
    //get the difference between time now and first event of the day.
    int diff = [formate stringFromDate:returnEvent.date].intValue - [formate stringFromDate:date].intValue;
    
    //run a loop through
    for (int i = 0; i < realm.count; i++) {
        Events *e = [realm objectAtIndex:i];
        
        //see of the difference in time of the current event and current date
        int Cdiff = [formate stringFromDate:e.date].intValue - [formate stringFromDate:date].intValue;
        
        //if Cdiff is positive and larger than diff, then the returnEvent is that object.
        if (Cdiff > 0 && Cdiff < diff) {
            returnEvent = e;
        }
        
    }
    return returnEvent;
}

+(Projects *)findProjectWithName:(NSString *)name{
    
    RLMResults *re = [Projects allObjects];
    
    for (int i = 0; i < re.count; i++) {
        Projects *p = [re objectAtIndex:i];
        if ([p.title isEqualToString:name]) {
            return p;
        }
    }
    return nil;
}

+(NSMutableArray *)findImportantEvents:(NSDate *)date withRealm:(RLMResults *)realm{
    
    NSMutableArray *array = [EventsHelper findEventsForToday:date withRealm:realm];
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        Events *event = [realm objectAtIndex:i];
        if (event.important == YES) {
            [returnArray addObject:event];
        }
    }
    return returnArray;
}
@end
