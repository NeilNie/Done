//
//  EventsHelper.h
//  Done!
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsHelper : NSObject

-(void)createEventWithDate:(NSData *)date title:(NSString *)title location:(NSString *)location notes:(NSString *)notes;

@end
