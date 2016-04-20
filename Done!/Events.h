//
//  Events.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface Events : RLMObject
@property NSString *title;
@property NSString *subTitle;
@property NSDate *date;
@property NSString *location;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Events>
RLM_ARRAY_TYPE(Events)
