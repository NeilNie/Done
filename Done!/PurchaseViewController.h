//
//  PurchaseViewController.h
//  Done!
//
//  Created by Yongyang Nie on 5/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CalendarViewController.h"

@interface PurchaseViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
