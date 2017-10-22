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

#pragma mark - Private

-(void)setUpView{
    
    //create date formatter
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"hh:mm dd/MM"];
    
    //display the upcoming events.
    RLMResults *result = [Events allObjects];
    NSMutableArray *todo = [EventsHelper findTodayNotCompletedEvents:result];
    NSMutableArray *completed = [EventsHelper findTodayCompletedEvents:result];
    NSUInteger x = todo.count / completed.count * 100;
    
    //update user interface
    [self.image startAnimatingWithImagesInRange:NSMakeRange(0, x) duration:0.8 repeatCount:0];
    [self.todayLabel setText:[NSString stringWithFormat:@"%i/%i", todo.count, completed.count]];
}

#pragma mark - Life Cycle

- (void)awakeWithContext:(id)context {
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



