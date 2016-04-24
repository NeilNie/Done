//
//  InterfaceController.m
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

-(IBAction)send{
    
    [self.wormhole passMessageObject:@"updateRequested" identifier:@"idRequestUpdate"];
    NSLog(@"update request sent");

}
- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    
    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.done.com.watch"];
    NSString *realmPath = [directory.path stringByAppendingPathComponent:@"db.realm"];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL fileURLWithPath:realmPath];
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.done.com.watch" optionalDirectory:@"wormhole"];
    [self.wormhole passMessageObject:@"updateRequested" identifier:@"idRequestUpdate"];
    NSLog(@"update request sent");
    //    result = [wormhole messageWithIdentifier:@"idWatchSync"];
    //    NSLog(@"%@", result);

    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



