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
#import <SCLAlertView.h>

#import "Events.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "JTCalendar/JTCalendar.h"
#import "NYDate.h"

BOOL areAdsRemoved;

@interface CalendarViewController : UIViewController <JTCalendarDelegate, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{

    NSDate *dateSelected;
    NSMutableDictionary *eventsByDate;
    NSMutableArray *eventArray;
}

@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContr1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContr2;
@property (weak, nonatomic) IBOutlet UILabel *eventCountl;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConst3;
@end
