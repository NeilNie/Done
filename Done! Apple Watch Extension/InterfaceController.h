//
//  InterfaceController.h
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "MMWormhole.h"

@interface InterfaceController : WKInterfaceController{
    RLMResults *result;

}

@property (strong, nonatomic) MMWormhole *wormhole;

@end
