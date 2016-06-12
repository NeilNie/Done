//
//  AppDelegate.h
//  Done!
//
//  Created by Yongyang Nie on 4/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <Google/Analytics.h>
#import "MainViewController.h"

#define kMainViewController (MainViewController *)[UIApplication sharedApplication].delegate.window.rootViewController

@import Firebase;
@import FirebaseAuth;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

