//
//  AppDelegate.h
//  Done!
//
//  Created by Yongyang Nie on 4/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "EventManager.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) EventManager *eventManager;
@property (strong, nonatomic) WCSession *session;

@end
