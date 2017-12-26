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

#import <MaterialControls/MaterialControls.h>
#import "Task.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "List.h"
#import "AddEventCell.h"
#import "MDDeviceHelper.h"
#import "UIView+MDExtension.h"
#import "Done_-Swift.h"

BOOL phoneModified;

@interface TodoViewController : UIViewController <WCSessionDelegate, UITableViewDelegate, UITableViewDataSource, EventCellDelegate, SWTableViewCellDelegate, AddEventCellDelegate, MDTabBarDelegate, MDButtonDelegate>{

    NSMutableArray *allEvents; //an array of Event objects
    NSMutableArray *tabBarArray;
    NSInteger selected;
    BOOL sameSelection;
}
@property (weak, nonatomic) IBOutlet MDTabBar *tabBar;
@property (weak, nonatomic) IBOutlet MDButton *btMore;
@property (weak, nonatomic) IBOutlet MDButton *btAddEvent;
@property (weak, nonatomic) IBOutlet MDButton *btAddProject;
@property (weak, nonatomic) IBOutlet MDButton *btEdit;
@property (strong, nonatomic) List *list;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableButtom;

@end
