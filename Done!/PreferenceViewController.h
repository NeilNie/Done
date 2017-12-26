//
//  PreferenceViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "List.h"
#import "Task.h"
#import "EventsHelper.h"
#import "AnalysisViewController.h"

@import FirebaseAuth;

BOOL areAdsRemoved2;

@interface PreferenceViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    NSMutableArray *array;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
