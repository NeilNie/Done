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

+(void)createRealmWithArray:(NSMutableArray *)array{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dic = [array objectAtIndex:i];
        [realm beginWriteTransaction];
        Events *NewEvent = [[Events alloc] init];
        NewEvent.title = [dic objectForKey:@"title"];
        NewEvent.date = [formate dateFromString:[dic objectForKey:@"date"]];
        [realm addObject:NewEvent];
        [realm commitWriteTransaction];
    }
}

+(void)eventsAreModified:(id)object{
    
    if(WCSession.isSupported){
        NSLog(@"sent request");
        WCSession *session = [WCSession defaultSession];
        session.delegate = object;
        [session activateSession];
        [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
        NSLog(@"updated context");
    }
}


@end
