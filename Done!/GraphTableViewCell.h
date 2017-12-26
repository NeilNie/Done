//
//  GraphTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 7/20/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "EventsHelper.h"
#import "Task.h"

typedef NS_ENUM( NSInteger, GraphType ) {
    PNPieGraph,
    PNLineGraph,
    PNBarGraph
};

@interface GraphTableViewCell : UITableViewCell <PNChartDelegate>

@property GraphType graphType;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) PNBarChart* barChart;
@property (strong, nonatomic) PNLineChart* lineChart;
@property (strong, nonatomic) PNPieChart* pieChart;
@property (assign, nonatomic) id delegate;
-(void)setUpGraphType:(GraphType)type;

@end

@protocol GraphTableViewDelegate <NSObject>

@required

@optional

@end
