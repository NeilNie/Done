//
//  TodayViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "Events.h"
#import "Projects.h"

BOOL areAdsRemoved;

@interface TodayViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end
