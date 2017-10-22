//
//  GraphTableViewCell.m
//  Done!
//
//  Created by Yongyang Nie on 7/20/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "GraphTableViewCell.h"

@implementation GraphTableViewCell

-(void)setUpGraphType:(GraphType)type{
    
    switch (type) {
        case PNPieGraph:
            [self setUpPieGraph];
            break;
        case PNLineGraph:
            [self setUpLineChart];
            break;
            
        default:
            break;
    }
}

-(NSMutableArray *)getLineData{
    
    RLMResults *events = [Events allObjects];
    NSMutableArray *lineData = [NSMutableArray array];
    NSMutableArray *completed = [NSMutableArray array];
    NSMutableArray *total = [NSMutableArray array];
    
    for (int i = 6; i >= 0; i--) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:i * -(60 * 60 * 24)];
        NSMutableArray *a = [EventsHelper findCompletedEventsRealm:events withDate:date];
        NSMutableArray *a2 = [EventsHelper findEventsForToday:date withRealm:events];
        [completed addObject:[NSNumber numberWithInteger:a.count]];
        [total addObject:[NSNumber numberWithInteger:a2.count]];

    }
    [lineData addObject:completed];
    [lineData addObject:total];
    
    return lineData;
}

-(NSMutableArray *)getPieGraphData{
    
    NSMutableArray *array = [NSMutableArray array];
    
    RLMResults *result = [Projects allObjects];
    for (int i = 0; i < result.count; i++) {
        Projects *p = [result objectAtIndex:i];
        [array addObject:[PNPieChartDataItem dataItemWithValue:p.events.count color:[UIColor colorWithRed:(86 - i*3)/255.0 green:(220 - i*12)/255.0 blue:(128 - i*3)/255.0 alpha:1.0] description:p.title]];
    }
    
    return array;
}

-(void)setUpPieGraph{
    
    self.titleLabel.text = NSLocalizedString(@"Pie Chart", nil);

    NSArray *items = [self getPieGraphData];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 120.0, 40, 240.0, 240.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(self.frame.size.width/2 - 120.0, self.pieChart.frame.origin.y + 260, legend.frame.size.width, legend.frame.size.height)];
    [self addSubview:legend];
    [self addSubview:self.pieChart];
}

-(void)setUpLineChart{
    
    self.titleLabel.text = NSLocalizedString(@"Line Chart", nil);
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(8, 30, self.frame.size.width - 16, 200.0)];
    self.lineChart.yLabelFormat = @"%1.1f";
    self.lineChart.backgroundColor = [UIColor clearColor];
    [self.lineChart setXLabels:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    self.lineChart.showCoordinateAxis = YES;
    self.lineChart.showYGridLines = YES;
    
    // Line Chart #1
    NSArray * data01Array = [[self getLineData] objectAtIndex:0];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Completed";
    data01.color = PNRed;
    data01.alpha = 0.3f;
    data01.lineWidth = 4.0;
    data01.itemCount = data01Array.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
    NSArray * data02Array = [[self getLineData] objectAtIndex:1];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"Total";
    data02.color = PNTwitterColor;
    data02.alpha = 0.5f;
    data02.lineWidth = 4.0;
    data02.itemCount = data02Array.count;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01, data02];
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
    [self addSubview:self.lineChart];
    
    self.lineChart.legendStyle = PNLegendItemStyleStacked;
    self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    self.lineChart.legendFontColor = [UIColor darkGrayColor];
    
    UIView *legend = [self.lineChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(self.lineChart.frame.origin.x, self.lineChart.frame.origin.y + 210, legend.frame.size.width, legend.frame.size.width)];
    [self addSubview:legend];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
