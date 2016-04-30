//
//  InterfaceController.h
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "EventsHelper.h"

@interface InterfaceController : WKInterfaceController <WCSessionDelegate> {
    RLMResults *result;
}

@end
