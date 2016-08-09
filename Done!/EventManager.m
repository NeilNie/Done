//
//  EventManager.m
//  
//
//  Created by Yongyang Nie on 6/17/16.
//
//

#import "EventManager.h"

@implementation EventManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = NO;
        }        
    }
    return self;
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    _eventsAccessGranted = eventsAccessGranted;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

-(NSArray *)getLocalEventCalendars{
    
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    for (int i=0; i<allCalendars.count; i++) {
        
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    return (NSArray *)localCalendars;
}

-(NSArray *)getTodayEventCalendars{
    
    NSArray *allCalendars = [self getLocalEventCalendars];
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NYDate todayStarts] endDate:[NYDate tomorrowStarts] calendars:allCalendars];
    NSArray *todayEvents = [self.eventStore eventsMatchingPredicate:predicate];
    return todayEvents;
}

-(NSMutableArray <Events *> *)convertEKEventtoEvents{
    
    NSMutableArray *eventsToday = [[NSMutableArray alloc] initWithArray:[self getTodayEventCalendars]];
    
    if (eventsToday.count == 0) {
        return nil;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i = 0; i < eventsToday.count; i++) {
        EKEvent *EKEvent = [eventsToday objectAtIndex:i];
        Events *event = [[Events alloc] init];
        event.title = EKEvent.title;
        event.date = EKEvent.startDate;
        event.endDate = EKEvent.endDate;
        [returnArray addObject:event];
    }
    return returnArray;
}

-(NSArray<NYTimePeriod *> *)busyTimesToday{
    
    NSMutableArray *eventsToday = [self convertEKEventtoEvents];
    [eventsToday addObjectsFromArray:[EventsHelper findTodayNotCompletedEvents:[Events allObjects]]];
    
    NSMutableArray *periodArray = [NSMutableArray array];
    for (int i = 0; i < eventsToday.count; i++) {
        
        Events *event = [eventsToday objectAtIndex:i];
        
        if (event.endDate) {
            NYTimePeriod *period = [[NYTimePeriod alloc] initWithStart:event.date andEnd:event.endDate];
            [periodArray addObject:period];
        }else{
            NYTimePeriod *period = [[NYTimePeriod alloc] initWithStart:event.date andEnd:[NSDate dateWithTimeInterval:1200 sinceDate:event.date]];
            [periodArray addObject:period];
        }
    }
    NSArray *result = [eventsToday sortedArrayUsingComparator:^NSComparisonResult(Events *event1, Events *event2) {
        return [event1.date compare:event2.date];
    }];
    return result;
}

-(NSMutableArray <Events *> *)convertPeriodsToEvents:(NSArray *)periods{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i = 0; i < periods.count; i++) {
        NYTimePeriod *period = [periods objectAtIndex:i];
        Events *event = [[Events alloc] init];
        event.date = period.startDate;
        event.endDate = period.endDate;
        event.title = NSLocalizedString(@"Free time", nil);
        [returnArray addObject:event];
    }
    return returnArray;
}


-(NSMutableArray<NYTimePeriod *> *)freeTimesToday{
    
    NSMutableArray *busyTimes = [self busyTimesToday];
    NSMutableArray *freePeriods = [NSMutableArray array];
    
    ////1
    //go through all the busy periods in the day, and find the gaps between each peroids.
    if (busyTimes.count >= 1) {
        for (int i = 0; i < busyTimes.count - 1; i++) {
            
            Events *current = [busyTimes objectAtIndex:i];
            Events *next = [busyTimes objectAtIndex:i + 1];
            
            //if the gap between the events are more than 5 minutes, then create a NYTimePeriod object and add it to the array.
            if ([current.endDate timeIntervalSinceDate:next.date] < - 15 * 60) { // if
                NYTimePeriod *freePeriod = [[NYTimePeriod alloc] initWithStart:[NSDate dateWithTimeInterval:10 * 60 sinceDate:current.endDate] andEnd:[NSDate dateWithTimeInterval:-10 * 60 sinceDate:next.date]];
                [freePeriods addObject:freePeriod];
            }
        }
        
        ////2
        //if the first event of the day is after 9, then
        NSDate *todayAtEight = [NYDate getDateTodayWithHour:8 minutes:0];
        Events *firstPeriod = [busyTimes objectAtIndex:0];
        
        //
        if ([todayAtEight timeIntervalSinceDate:firstPeriod.date] > 20 * 60) {
            
        }
    }else{
        return nil;
    }
    
    return freePeriods;
}

@end
