//
//  TodoViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "Events.h"

@interface TodoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    RLMResults *result;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@end
