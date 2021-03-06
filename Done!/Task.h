//
//  Task.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface Task : RLMObject

@property NSString *uoid;
@property NSString *title;
@property NSDate *date;
@property NSDate *endDate;
@property BOOL completed;
@property BOOL important;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Events>
RLM_ARRAY_TYPE(Task)
