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
#import "EventTableViewCell.h"
#import "MMWormhole.h"

@interface TodoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EventCellDelegate>{
    RLMResults *result;
    UIRefreshControl *refresh;
    MMWormhole *wormhole;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *item;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
