//
//  InterfaceController.m
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end

@implementation InterfaceController

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    NSLog(@"%ld", (long)activationState);
    NSLog(@"%@", error);
}

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    NSLog(@"application context %@", applicationContext);
}

-(void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo{
    
        //reply handler, delete old database,
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];

    //create new database with replyMessage, get main queue and update table
    NSMutableArray *array = [userInfo objectForKey:@"data"];
    if ([array count] > 0) {
        [EventsHelper createRealmWithArray:array];
        [Timer invalidate];
    }
}

#pragma mark - Privates

-(void)startTimer{
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        count++;
        if (count == 5) {
            //show alert;
            WKInterfaceController *alert = [[WKInterfaceController alloc] init];
            WKAlertAction *action = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^{
                [alert dismissController];
                [Timer invalidate];
            }];
            [alert presentAlertControllerWithTitle:@"Opps, unable to sync data." message:@"Please press the sync button to resync data with your phone." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
        }
    }];
}

-(IBAction)syncDataWithCounterpart{
    
    if (session.reachable) {
        NSLog(@"will request data");
        [session activateSession];
        [session transferUserInfo:@{@"key": @"syncRequest"}];
        [self startTimer];
    }else{
        WKInterfaceController *alert = [[WKInterfaceController alloc] init];
        WKAlertAction *action = [WKAlertAction actionWithTitle:@"OK" style:WKAlertActionStyleCancel handler:^{
            [alert dismissController];
        }];
        [alert presentAlertControllerWithTitle:@"Sorry, can't reach your iPhone" message:@"Please make sure that your iPhone is connected to the Apple Watch. We are trying to sync data." preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
    }
}

-(void)setUpView{
    
    //create date formatter
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"hh:mm dd/MM"];
    
    //display the upcoming events.
    RLMResults *result = [Task allObjects];
    Task *event = [EventsHelper findMostRecentEvent:[NSDate date] withRealmResult:result];
    [self.upcomingDate setText:[NSString stringWithFormat:@"%@", [formate stringFromDate:event.date]]];
    [self.upcomingEvent setText:[NSString stringWithFormat:@"%@", event.title]];
    
    NSMutableArray *todo = [EventsHelper findTodayNotCompletedEvents:result];
    NSMutableArray *completed = [EventsHelper findTodayCompletedEvents:result];
    NSUInteger x = todo.count / completed.count * 100;
    [self.image startAnimatingWithImagesInRange:NSMakeRange(0, x) duration:0.8 repeatCount:0];
    [self.todayLabel setText:[NSString stringWithFormat:@"%i/%i", todo.count, completed.count]];
}

#pragma mark - Life Cycle

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {

    if ([WCSession isSupported]) {
        session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
        do {
            NSLog(@"not active");
        } while ([session activationState] == WCSessionActivationStateInactive || [session activationState] == WCSessionActivationStateNotActivated);
        
        if (session.receivedApplicationContext != session.applicationContext) {
            [self syncDataWithCounterpart];
        }else if (session.applicationContext == nil || session.receivedApplicationContext == nil){
            [self syncDataWithCounterpart];
        }
    }

    CLKComplicationServer *complicationServer = [CLKComplicationServer sharedInstance];
    for (CLKComplication *complication in complicationServer.activeComplications) {
        NSLog(@"reloaded complication");
        [complicationServer reloadTimelineForComplication:complication];
    }
    
    [self setUpView];
    [self.image setImageNamed:@"progress"];
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end
