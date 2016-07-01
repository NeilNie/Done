//
//  AppDelegate.m
//  Done!
//
//  Created by Yongyang Nie on 4/17/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "AppDelegate.h"
#import <Realm/Realm.h>
#import "EventsHelper.h"
#import "Events.h"
#import "TipsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.eventManager = [[EventManager alloc] init];
    [FIRApp configure];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBar.png"]];
    [[UITabBar appearance] setTintColor:[UIColor lightGrayColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateSelected];
    
    application.applicationIconBadgeNumber = 0;
    //register for notification
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    UIViewController *startView = [storyboard instantiateViewControllerWithIdentifier:@"userAuth"];
    self.window.rootViewController = navigationController;
    if (user == nil) {
        self.window.rootViewController = startView;
        [self.window makeKeyAndVisible];
    }else{
        [UIView transitionWithView:self.window
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
    }
    

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if(WCSession.isSupported){
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {

    }
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - WCSession Delegate

-(void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext{
    NSLog(@"received application context %@", applicationContext);
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    NSLog(@"received message");
    NSMutableArray *array = [EventsHelper convertAllObjecttoArray];
    WCSession *wcsession = [WCSession defaultSession];
    wcsession.delegate = self;
    [wcsession activateSession];
    replyHandler(@{@"data": array});
    NSLog(@"sent reply");
}

-(void)sessionWatchStateDidChange:(WCSession *)session{
    NSLog(@"watch status changed");
}
-(void)sessionDidDeactivate:(WCSession *)session{
    NSLog(@"session deactivated");
}

@end
