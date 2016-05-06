//
//  CalendarViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar/JTCalendar.h"
#import <Realm/Realm.h>

#import "Events.h"
#import "EventTableViewCell.h"

@interface CalendarViewController : UIViewController <JTCalendarDelegate, UITableViewDataSource, UITableViewDelegate>{

    NSDate *dateSelected;
    NSMutableDictionary *eventsByDate;
    NSMutableArray *eventArray;
}

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
