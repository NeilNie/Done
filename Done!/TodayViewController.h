//
//  TodayViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <LGSideMenuController/LGSideMenuController.h>

#import "AppDelegate.h"
#import "Events.h"
#import "Projects.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "CreateNewVC.h"
#import "PurchaseViewController.h"

#import "MSCollectionViewCalendarLayout.h"
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "iOSUILib/MDRippleLayer.h"
#import "GraphKit.h"


@import GoogleMobileAds;
@import FirebaseAuth;

@interface TodayViewController : UIViewController <MSCollectionViewDelegateCalendarLayout, UITableViewDelegate, UITableViewDataSource, GKLineGraphDataSource>{
    NSMutableArray *allEvents;
    RLMResults *result;
}
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *completedData;
@property (strong, nonatomic) NSMutableArray *eventNumber;
@property (nonatomic, strong) NSArray *labels;

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@property (weak, nonatomic) IBOutlet UIView *completedEView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completedConst;
@property (weak, nonatomic) IBOutlet UIView *totalEView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvConst;
@property (weak, nonatomic) IBOutlet GKLineGraph *graphView;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayConst;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet MDSwitch *switchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contr;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingTitle;
@property (weak, nonatomic) IBOutlet UILabel *upcomingTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContr;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property(nonatomic) UIColor *rippleColor;
@end
