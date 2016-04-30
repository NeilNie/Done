//
//  TodayEvents.h
//  Done!
//
//  Created by Yongyang Nie on 4/24/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "Row.h"
#import "Events.h"
#import "EventsHelper.h"

BOOL updated;

@interface TodayEvents : WKInterfaceController <WCSessionDelegate>{
    
    RLMResults *result;
}
@property (strong, nonatomic) WCSession *session;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;

@end
