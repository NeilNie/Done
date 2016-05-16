//
//  AnalysisViewController.h
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <MKFoundationKit/MKFoundationKit.h>
#import <SCLAlertView.h>

#import "Projects.h"
#import "EventsHelper.h"
#import "Events.h"
#import "GraphKit.h"
#import "CalendarViewController.h"

@interface AnalysisViewController : UIViewController <GKLineGraphDataSource, GKBarGraphDataSource>

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *eventNumber;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *barData;
@property (weak, nonatomic) IBOutlet GKLineGraph *lineGraph;
@property (weak, nonatomic) IBOutlet GKBarGraph *barGraph;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphConst;

@end
