//
//  TableViewController.h
//  Done!
//
//  Created by Yongyang Nie on 7/8/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "Projects.h"

@interface TableViewController : UITableViewController
@property (strong, nonatomic) RLMResults *array;

@end
