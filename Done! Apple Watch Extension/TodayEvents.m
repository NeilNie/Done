//
//  TodayEvents.m
//  Done!
//
//  Created by Yongyang Nie on 4/24/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayEvents.h"

@interface TodayEvents ()

@end

@implementation TodayEvents

- (void)setupTable
{
    [self.table setNumberOfRows:events.count withRowType:@"default"];
    
    NSInteger rowCount = self.table.numberOfRows;
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        Events *event = [events objectAtIndex:i];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        Row *row = [self.table rowControllerAtIndex:i];
        [row.title setText:event.title];
        [row.date setText:[formate stringFromDate:event.date]];
    }
    [self.table setHidden:NO];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.done.com.watch" optionalDirectory:@"wormhole"];
    [wormhole passMessageObject:@"requestUpdate" identifier:@"idRequestUpdate"];
    NSLog(@"update request sent");
    events = [wormhole messageWithIdentifier:@"idWatchSync"];
    NSLog(@"%@", events);
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



