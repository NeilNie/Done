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

-(NSMutableArray<NYTimePeriod *> *)busyTimesToday{
    
    NSArray *eventsToday = [self getTodayEventCalendars];
    
    NSMutableArray *periodArray = [NSMutableArray array];
    for (int i = 0; i < eventsToday.count; i++) {
        EKEvent *event = [eventsToday objectAtIndex:i];
        NYTimePeriod *period = [[NYTimePeriod alloc] initWithStart:event.startDate andEnd:event.endDate];
        [periodArray addObject:period];
    }
    return periodArray;
}

-(NSMutableArray<NYTimePeriod *> *)freeTimesToday{
    
    NSMutableArray *busyTimes = [self busyTimesToday];
    NSMutableArray *freePeriods = [NSMutableArray array];
    
    ////1
    //go through all the busy periods in the day, and find the gaps between each peroids.
    for (int i = 0; i < busyTimes.count - 1; i++) {
        
        NYTimePeriod *current = [busyTimes objectAtIndex:i];
        NYTimePeriod *next = [busyTimes objectAtIndex:i + 1];
        
        //if the gap between the events are more than 5 minutes, then create a NYTimePeriod object and add it to the array.
        if ([current.endDate timeIntervalSinceDate:next.startDate] < - 5 * 60) { // if
            NYTimePeriod *freePeriod = [[NYTimePeriod alloc] initWithStart:current.endDate andEnd:next.startDate];
            [freePeriods addObject:freePeriod];
        }
    }
    
    ////2
    //if the first event of the day is after 9, then
    NSDate *todayAtEight = [NYDate getDateTodayWithHour:8 minutes:0];
    NYTimePeriod *firstPeriod = [busyTimes objectAtIndex:0];
    
    //
    if ([todayAtEight timeIntervalSinceDate:firstPeriod.startDate] > 10 * 60) {
        
    }
    
    return freePeriods;
}

@end
