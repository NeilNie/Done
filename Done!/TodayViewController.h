//
//  TodayViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "AppDelegate.h"
#import "Events.h"
#import "Projects.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "CreateNewVC.h"
#import "PurchaseViewController.h"
#import "GraphKit.h"
#import "NYDate.h"

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

@import FirebaseAuth;

@interface TodayViewController : UIViewController <MSCollectionViewDelegateCalendarLayout,GKLineGraphDataSource, CreateNewDelegate, UIViewControllerPreviewingDelegate>{
    NSMutableArray *allEvents;
    RLMResults *result;
    NSArray *collectionViewArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@property (weak, nonatomic) IBOutlet GKLineGraph *graphView;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contr;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContr;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayConstr;
@property (weak, nonatomic) IBOutlet UIButton *preferenceButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphConstr;

@end
