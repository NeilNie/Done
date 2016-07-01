//
//  NYTimePeriod.m
//  Done!
//
//  Created by Yongyang Nie on 6/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "NYTimePeriod.h"

@implementation NYTimePeriod

- (instancetype)initWithStart:(NSDate *)start andEnd:(NSDate *)end
{
    self = [super init];
    if (self) {
        self.startDate = start;
        self.endDate = end;
    }
    return self;
}
@end
