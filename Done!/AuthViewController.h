//
//  UserAuthViewController.h
//  Done!
//
//  Created by Yongyang Nie on 5/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaterialControls/MaterialControls.h>
#import "PCAngularActivityIndicatorView.h"
#import <Parse/Parse.h>

@interface AuthViewController : UIViewController <MDTextFieldDelegate>

@property (strong, nonatomic) PCAngularActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet MDTextField *password;
@property (weak, nonatomic) IBOutlet MDTextField *email;
@property (strong, nonatomic) UIWindow *window;

@end
