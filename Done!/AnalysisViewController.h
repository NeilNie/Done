//
//  AnalysisViewController.h
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "List.h"
#import "EventsHelper.h"
#import "Task.h"
#import "CalendarViewController.h"
#import "GraphTableViewCell.h"

@interface AnalysisViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *array;
    NSMutableArray *eventNumber;
    NSArray *labels;
    NSArray *data;
    NSMutableArray *barData;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
