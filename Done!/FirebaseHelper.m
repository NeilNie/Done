//
//  FirebaseHelper.m
//  Done!
//
//  Created by Yongyang Nie on 5/29/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "FirebaseHelper.h"

@implementation FirebaseHelper

@synthesize ref;

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    if (self) {
        ref = [[FIRDatabase database] reference];
    }
    return self;
}

#pragma mark - Class Methods

-(void)createRealmWithBackup{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    [[[ref child:@"projects"] child:user.displayName] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if ([snapshot.value class] != [NSNull class]) {
            
            for (NSDictionary *dic in snapshot.value) {
               
                //create a project
                NSString *title = [dic objectForKey:@"project_title"];
                NSDate *date = [[self dateFormatter] dateFromString:[dic objectForKey:@"project_date"]];
                Projects *project = [EventsHelper createProjectWithDate:date title:title]; //create the project
                project = [self addEventsToProjects:project withEvents:[self eventsArrayWithKeys:[dic objectForKey:@"events"]]]; //add events to the project
                
                //add project to realm
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm addObject:project];
                [realm commitWriteTransaction];
            }
        }else{
            return;
        }
    }];
}

-(void)addProjectToFirebase:(Projects *)project{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSLog(@"username %@", user.displayName);
    NSString *projectID = [self uuid];
    [[[[ref child:@"projects"] child:user.displayName] child:project.title] setValue:@{@"project_title": project.title,
                                                                                        @"project_id":projectID,
                                                                                        @"project_date": [[self dateFormatter] stringFromDate:project.date],
                                                                                        @"events":[NSMutableArray array]}];
}

-(void)addEventToFirebase:(Events *)event addedToProject:(Projects *)addedToProject{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *eventID = [self uuid];
    [[[ref child:@"events"] child:eventID] setValue:@{@"event_title": event.title,
                                                       @"event_date": [[self dateFormatter] stringFromDate:event.date],
                                                      @"completed": @0,
                                                      @"important": @0,
                                                       @"owner": user.displayName
                                                       }];
    [[[[ref child:@"projects"] child:user.displayName] child:addedToProject.title] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        __block NSMutableArray *UpdateArray;
        NSLog(@"snap %@", snapshot.value);
        if ([snapshot.value class] == [NSNull class]) {
            UpdateArray = [NSMutableArray array];
        }else{
            UpdateArray = [snapshot.value objectForKey:@"events"];
        }
        [UpdateArray addObject:eventID];
        NSDictionary *updateDic = @{[NSString stringWithFormat:@"projects/%@/%@/events", user.displayName, addedToProject.title]:UpdateArray};
        [ref updateChildValues:updateDic];
    }];
}

#pragma mark - Helper Methods

-(NSMutableArray *)eventsArrayWithKeys:(NSMutableArray *)array{
    
    NSMutableArray *eventArray = [NSMutableArray array];
    for (int x = 0; x < array.count; x++) {
        
        [[[ref child:@"events"] child:array[x]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *dic = snapshot.value;
            NSDate *date = [[self dateFormatter] dateFromString:[dic objectForKey:@"event_date"]];
            Events *event = [EventsHelper createEventWithDate:date title:[dic objectForKey:@"event_title"] otherInfo:nil];
            [eventArray addObject:event];
        }];
    }
    return eventArray;
}

-(Projects *)addEventsToProjects:(Projects *)project withEvents:(NSMutableArray *)array{
    
    for (int x = 0; x < array.count; x++) {
        [project.events addObject:array[x]];
    }
    return project;
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
    }
    return dateFormatter;
}

@end
