//
//  EventManager.h
//  
//
//  Created by Yongyang Nie on 6/17/16.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "NYDate.h"
#import "NYTimePeriod.h"

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

-(NSArray *)getLocalEventCalendars;
-(NSArray *)getTodayEventCalendars;
-(NSMutableArray<NYTimePeriod *> *)busyTimesToday;
-(NSMutableArray<NYTimePeriod *> *)freeTimesToday;

@end
