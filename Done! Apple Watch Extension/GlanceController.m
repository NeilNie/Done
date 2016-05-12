//
//  GlanceController.m
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"@ HH:mm MM/dd"];
    
    NSMutableArray *todayEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:[Events allObjects]];
    Events *recent = [EventsHelper findMostRecentEvent:[NSDate date] withRealm:todayEvents];
    [self.titleLabel setText:recent.title];
    [self.dateLabel setText:[formate stringFromDate:recent.date]];
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



