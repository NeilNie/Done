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
#import "Row.h"
#import "Events.h"
#import "MMWormhole.h"

@interface TodayEvents : WKInterfaceController{
    RLMResults *events;
    MMWormhole *wormhole;
}

@property (weak, nonatomic) WKInterfaceTable *table;

@end
