//
//  EventsHelper.m
//  Done!
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "EventsHelper.h"

@implementation EventsHelper

+(void)createEventWithDate:(NSDate *)date title:(NSString *)title otherInfo:(NSDictionary *)info{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    Events *NewEvent = [[Events alloc] init];
    NewEvent.title = title;
    NewEvent.date = date;
    [realm addObject:NewEvent];
    [realm commitWriteTransaction];
    
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
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int i = 0; i < results.count; i++) {
        
        Events *event = [results objectAtIndex:i];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:event.title forKey:@"title"];
        [dictionary setValue:[formate stringFromDate:event.date] forKey:@"date"];
        
        [arry addObject:dictionary];
    }
    return arry;
}

+(NSMutableArray *)convertAllObjecttoArray{
    
    NSMutableArray *arry = [NSMutableArray array];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
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
            [es addObject:dic];
        }
        [dic setValue:es forKey:@"events"];
        
        [arry addObject:dic];
    }
    return arry;
}

+(void)createRealmWithArray:(NSMutableArray *)array{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
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
            [pro.events addObject:e];
        }
        [realm addObject:pro];
        [realm commitWriteTransaction];
    }
    
}

+(NSMutableArray *)findEventsForToday:(NSDate *)today withRealm:(RLMResults *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < realm.count; i++) {
        
        Events *event = [realm objectAtIndex:i];
        if ([[formate stringFromDate:today] isEqualToString:[formate stringFromDate:event.date]]) {
            [array addObject:event];
        }
    }
    return array;
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

+(NSMutableArray *)findCompletedEvents:(RLMArray *)realm{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == YES) {
            [array addObject:event];
        }
    }
    return array;
}
+(NSMutableArray *)findCompletedEvents:(NSMutableArray *)realm withDate:(NSDate *)date{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];

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
    [formate setDateFormat:@"yyyy-MM-dd"];
    
    for (int i = 0; i < realm.count; i ++) {
        
        Events *event = [realm objectAtIndex:i];
        if (event.completed == YES && [[formate stringFromDate:date] isEqualToString:[formate stringFromDate:event.date]]) {
            [array addObject:event];
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

+(Events *)findEventWithTitle:(NSString *)string withRealm:(RLMArray *)array{
    
    Events *event = [[Events alloc] init];
    for (int i = 0; i < array.count; i++) {
        
        Events *e = [array objectAtIndex:i];
        if ([e.title isEqualToString:string]) {
            return e;
        }
    }
    return event;
}

@end
