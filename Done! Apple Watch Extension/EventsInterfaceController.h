//
//  EventsInterfaceController.h
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "Row.h"
#import "Events.h"
#import "EventsHelper.h"
#import "Projects.h"

@interface EventsInterfaceController : WKInterfaceController{
    RLMArray *array;
}
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;

@end
