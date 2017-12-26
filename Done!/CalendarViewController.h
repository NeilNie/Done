//
//  CalendarViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <Realm/Realm.h>

#import "Task.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "JTCalendar/JTCalendar.h"
#import "Date.h"

BOOL areAdsRemoved;

@interface CalendarViewController : UIViewController <UITableViewDelegate, UITableViewDelegate, JTCalendarDelegate>{

    NSDate *dateSelected;
    NSMutableArray *eventArray;
}

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContr1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContr2;
@property (weak, nonatomic) IBOutlet UILabel *eventCountl;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConst3;
@end
