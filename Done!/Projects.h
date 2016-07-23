//
//  Projects.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>
#import "Events.h"

@interface Projects : RLMObject

@property NSString *title;
@property NSDate *date;
@property int priority;
@property NSString *location;
@property RLMArray<Events *><Events> *events;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Projects>
RLM_ARRAY_TYPE(Projects)
