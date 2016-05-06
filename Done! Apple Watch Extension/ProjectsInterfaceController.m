//
//  TodayEvents.m
//  Done!
//
//  Created by Yongyang Nie on 4/24/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ProjectsInterfaceController.h"

@interface ProjectsInterfaceController ()

@end

@implementation ProjectsInterfaceController

#pragma mark - WCSession Delegate

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    
    NSLog(@"received context (delegate method) %@", applicationContext);
    [self checkModification:applicationContext];
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    NSMutableArray *array = [message objectForKey:@"data"];
    if (array.count > 0) {
        //reply handler, delete old database,
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
        
        //create new database with replyMessage, get main queue and update table
        [EventsHelper createRealmWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTable];
            NSLog(@"%@", message);
        });
    }
    
}

#pragma mark Private

- (void)setupTable
{
    NSLog(@"setting up table");
    [self.table setNumberOfRows:result.count withRowType:@"default"];
    
    NSInteger rowCount = self.table.numberOfRows;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (NSInteger i = 0; i < rowCount; i++) {
        
        Projects *pro = [result objectAtIndex:i];
        Row *row = [self.table rowControllerAtIndex:i];
        [row.titleLabel setText:pro.title];
        [row.date setText:[formate stringFromDate:pro.date]];
    }
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    Projects *p = [result objectAtIndex:rowIndex];
    [self pushControllerWithName:@"Events" context:p.events];
}

-(void)syncDataWithCounterpart{
    
    if ([self.session isReachable]) {
        
        NSLog(@"will request data");
        
        [self.session sendMessage:@{@"key": @"syncRequest"} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            
            //reply handler, delete old database,
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteAllObjects];
            [realm commitWriteTransaction];
            
            //create new database with replyMessage, get main queue and update table
            if (replyMessage != nil) {
                [EventsHelper createRealmWithArray:[replyMessage objectForKey:@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    result = [Projects allObjects];
                    [self setupTable];
                    NSLog(@"%@", replyMessage);
                    
                });
            }
            
        } errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else{
        NSLog(@"session not reacheable");
    }
}

-(void)checkModification:(NSDictionary *)dictionary{
    
    if ([[dictionary objectForKey:@"needSync"] isEqualToString:@"YES"]) {
        
        NSLog(@"updated context to no");
        //there are modification, therefore, update application context
        [self syncDataWithCounterpart];
        if (result.count > 0) {
            [self.session updateApplicationContext:@{@"needSync":@"NO"} error:nil];
        }
    }
}

#pragma mark - Lifecycle

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        result = [Projects allObjects];
        NSLog(@"%@ %@", [Projects allObjects], [RLMRealm defaultRealm].configuration.fileURL);
        [self setupTable];
    });
    
    self.session = [WCSession defaultSession];
    self.session.delegate = self;
    [self.session activateSession];
    if (![self.session.applicationContext isEqual:self.session.receivedApplicationContext]) {
        [self checkModification:self.session.receivedApplicationContext];
    }
    
    CLKComplicationServer *complicationServer = [CLKComplicationServer sharedInstance];
    for (CLKComplication *complication in complicationServer.activeComplications) {
        NSLog(@"reloaded complication");
        [complicationServer reloadTimelineForComplication:complication];
    }
    [self syncDataWithCounterpart];
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



