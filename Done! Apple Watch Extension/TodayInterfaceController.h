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

#import "Task.h"
#import "EventsHelper.h"

@interface TodayInterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *image;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *completion;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *todayLabel;

@end
