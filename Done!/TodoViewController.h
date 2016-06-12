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

#import "Events.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "CreateNewVC.h"
#import "EventsHelper.h"
#import "Projects.h"
#import "PurchaseViewController.h"

BOOL phoneModified;

@import GoogleMobileAds;

@interface TodoViewController : UIViewController <WCSessionDelegate, UITableViewDelegate, UITableViewDataSource, EventCellDelegate>{
    NSMutableArray *allEvents;
    UIRefreshControl *refresh;
}
@property (weak, nonatomic) Projects *project;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviTitle;
@property (weak, nonatomic) IBOutlet UINavigationItem *item;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;

@end
