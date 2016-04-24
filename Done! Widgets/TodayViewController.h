//
//  TodayViewController.h
//  Done! Widgets
//
//  Created by Yongyang Nie on 4/21/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "EventTableViewCell.h"
#import "Events.h"

@interface TodayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *eventArray;
    NSMutableArray *result;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
