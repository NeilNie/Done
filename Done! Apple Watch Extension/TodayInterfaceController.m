//
//  TodayInterfaceController.m
//  Done!
//
//  Created by Yongyang Nie on 5/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayInterfaceController.h"

@interface TodayInterfaceController ()

@end

@implementation TodayInterfaceController

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM HH:mm";
    }
    
    return dateFormatter;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    
    result = [Events allObjects];
    NSMutableArray *allEvents = [EventsHelper findTodayNotCompletedEvents:result];
    Events *event = [EventsHelper findEarliestEventTodayWithArray:allEvents];
    [self.label1 setText:[NSString stringWithFormat:@"The first event of your day is %@ at %@", event.title, [[self dateFormatter] stringFromDate:event.date]]];
    [self.label2 setText:[NSString stringWithFormat:@"There are %lu events today and you have completed %lu of them.", (unsigned long)allEvents.count, (unsigned long)[EventsHelper findCompletedEventsWithArrayOfEvents:allEvents withDate:[NSDate date]].count]];
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



