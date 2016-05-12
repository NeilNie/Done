//
//  EventsInterfaceController.m
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "EventsInterfaceController.h"

@interface EventsInterfaceController ()

@end

@implementation EventsInterfaceController

- (void)setupTable
{
    NSLog(@"setting up table");
    [self.table setNumberOfRows:array.count withRowType:@"default"];
    
    NSInteger rowCount = self.table.numberOfRows;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        Events *event = [array objectAtIndex:i];
        Row *row = [self.table rowControllerAtIndex:i];
        [row.titleLabel setText:event.title];
        [row.date setText:[formate stringFromDate:event.date]];
    }
}

- (void)awakeWithContext:(id)context {
    
    array = context;
    [self setupTable];
    [super awakeWithContext:context];
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



