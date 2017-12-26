//
//  TodayTask.h
//  Done!
//
//  Created by Yongyang Nie on 4/24/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <ClockKit/ClockKit.h>
#import "Row.h"
#import "Task.h"
#import "EventsHelper.h"
#import "List.h"

BOOL updated;

@interface ProjectsInterfaceController : WKInterfaceController <WCSessionDelegate>{
    
    RLMResults *result;
}
@property (strong, nonatomic) WCSession *session;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;

@end
