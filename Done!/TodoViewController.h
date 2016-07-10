//
//  TodoViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <SWTableViewCell/SWTableViewCell.h>

#import "iOSUILib/MDTabBarViewController.h"
#import "Events.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "CreateNewVC.h"
#import "EventsHelper.h"
#import "Projects.h"
#import "PurchaseViewController.h"
#import "addEventCell.h"
#import "iOSUILib/MDButton.h"
#import "MDDeviceHelper.h"
#import "UIView+MDExtension.h"

BOOL phoneModified;

@interface TodoViewController : UIViewController <WCSessionDelegate, UITableViewDelegate, UITableViewDataSource, EventCellDelegate, SWTableViewCellDelegate, addEventCellDelegate, MDTabBarDelegate, CreateNewDelegate, MDButtonDelegate>{

    NSMutableArray *allEvents;
    NSMutableArray *tabBarArray;
    NSInteger selected;
    BOOL sameSelection;
}
@property (weak, nonatomic) IBOutlet MDTabBar *tabBar;
@property (weak, nonatomic) IBOutlet MDButton *btMore;
@property (weak, nonatomic) IBOutlet MDButton *btAddEvent;
@property (weak, nonatomic) IBOutlet MDButton *btAddProject;
@property (weak, nonatomic) IBOutlet MDButton *btEdit;
@property (strong, nonatomic) Projects *project;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *item;
@property (weak, nonatomic) IBOutlet UITableView *table;
//@property (weak, nonatomic) IBOutlet GADBannerView *banner;

@end
