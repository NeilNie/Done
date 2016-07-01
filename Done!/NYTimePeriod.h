//
//  NYTimePeriod.h
//  Done!
//
//  Created by Yongyang Nie on 6/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYTimePeriod : NSObject

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) NSTimeInterval interval;

- (instancetype)initWithStart:(NSDate *)start andEnd:(NSDate *)end;

@end
