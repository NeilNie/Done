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

-(void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error{
    
}

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    
    NSLog(@"received context (delegate method) %@", applicationContext);
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
        
        List *pro = [result objectAtIndex:i];
        Row *row = [self.table rowControllerAtIndex:i];
        [row.titleLabel setText:pro.title];
        [row.date setText:[formate stringFromDate:pro.date]];
    }
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    List *p = [result objectAtIndex:rowIndex];
    [self pushControllerWithName:@"Events" context:p.events];
}

#pragma mark - Lifecycle

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        result = [List allObjects];
        [self setupTable];
    });
    

    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end
