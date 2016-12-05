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
#import "Date.h"

#import "MSCollectionViewCalendarLayout.h"
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

BOOL areAdsRemoved;

@interface CalendarViewController : UIViewController <JTCalendarDelegate, MSCollectionViewDelegateCalendarLayout>{

    NSDate *dateSelected;
    NSMutableDictionary *eventsByDate;
    NSMutableArray *eventArray;
    NSArray *collectionViewArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
