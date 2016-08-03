//
//  NewEventViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <RKDropdownAlert.h>

#import "CustomCell.h"
#import "Events.h"
#import "EventsHelper.h"
#import "FirebaseHelper.h"
#import "TimelineTableViewCell.h"

@import FirebaseDatabase;
@import FirebaseAuth;

@protocol CreateNewDelegate <NSObject>

@optional
-(void)addNewEventToProject:(Events *)event;
@required
-(void)addProject:(Projects *)project;
@end

@interface CreateNewVC : UIViewController <WCSessionDelegate, UITableViewDelegate, UITableViewDataSource, CustomCellDelegates>{
    
    NSArray *array;
    
    NSString *title;
    NSString *subTitle;
    NSDate *date;
    NSString *location;

}
@property __strong NSNumber* reminder;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) Projects *addedToProject;
@property (nonatomic, assign) id <CreateNewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
