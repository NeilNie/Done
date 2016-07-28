//
//  PreferenceViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "Projects.h"
#import "Events.h"
#import "EventsHelper.h"
#import "AnalysisViewController.h"

BOOL areAdsRemoved2;

@import FirebaseAuth;

@interface PreferenceViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    NSMutableArray *array;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
