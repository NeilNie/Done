//
//  FirebaseHelper.h
//  Done!
//
//  Created by Yongyang Nie on 5/29/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

#import "Events.h"
#import "Projects.h"
#import "EventsHelper.h"

@import FirebaseAuth;
@import FirebaseDatabase;

@interface FirebaseHelper : NSObject

-(void)addEventToFirebase:(Events *)event addedToProject:(Projects *)addedToProject;
-(void)addProjectToFirebase:(Projects *)project;
-(void)createRealmWithBackup;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
