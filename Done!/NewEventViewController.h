//
//  NewEventViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "CustomCell.h"

@interface NewEventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CustomCellDelegates>{
    NSArray *array;
    NSMutableArray *cellDescriptors;
    NSMutableArray *visibleRowsPerSection;
    
    NSString *title;
    NSString *subTitle;
    NSDate *date;
    NSString *location;
    BOOL reminder;
}
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
