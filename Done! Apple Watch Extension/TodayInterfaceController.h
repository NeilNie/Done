//
//  TodayInterfaceController.h
//  Done!
//
//  Created by Yongyang Nie on 5/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "EventsHelper.h"

@interface TodayInterfaceController : WKInterfaceController{
    RLMResults *result;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *label1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *label2;

@end
