//
//  TodayViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "Projects.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"

BOOL areAdsRemoved;

@interface TodayViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *allEvents;
    RLMResults *result;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
