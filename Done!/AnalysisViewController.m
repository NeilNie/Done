//
//  AnalysisViewController.m
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "AnalysisViewController.h"

@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

#pragma mark - GKLineGraphDataSource

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.lineGraph.alpha == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.lineGraph.alpha = 1;
            self.barGraph.alpha = 0;
        }];

    }else if (self.lineGraph.alpha == 1){
        [UIView animateWithDuration:0.2 animations:^{
            self.lineGraph.alpha = 0;
            self.barGraph.alpha = 1;
        }];
    }
}

- (NSInteger)numberOfLines {
    return [self.data count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_orangeColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return [[@[@1.5, @2] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    return [self.barData count];
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    return [self.barData objectAtIndex:index];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    
    return [UIColor gk_pumpkinColor];
}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    
    return (1.0);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

- (void)setUpLineGraph{
    
    self.data = @[self.array,self.eventNumber];
    self.lineGraph.dataSource = self;
    self.lineGraph.lineWidth = 3.0;
    
    self.lineGraph.valueLabelCount = 5;
    
    [self.lineGraph draw];
}

-(void)setUpData{
    
    RLMResults *events = [Events allObjects];
    for (int i = 10; i > 0; i--) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:i * -(60 * 60 * 24)];
        NSMutableArray *a = [EventsHelper findCompletedEventsRealm:events withDate:date];
        NSMutableArray *a2 = [EventsHelper findEventsForToday:date withRealm:events];
        [self.array addObject:[NSNumber numberWithInteger:a.count]];
        [self.eventNumber addObject:[NSNumber numberWithInteger:a2.count]];
        
        float f;
        if (a2.count > 0) {
            f = (float)a.count / (float)a2.count * 100.0;
        }else{
            f = 0.0;
        }

        [self.barData addObject:[NSNumber numberWithFloat:f]];
    }

}

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft && self.graphConst > 0){
        
        [UIView animateWithDuration:1 animations:^{
            self.graphConst.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft && self.graphConst == 0){
        
        [UIView animateWithDuration:1 animations:^{
            self.graphConst.constant = [[UIScreen mainScreen] bounds].size.width;
            [self.view layoutIfNeeded];
        }];
        [self.barGraph draw];
    }
}

#pragma mark - Life Cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.lineGraph reset];
    self.lineGraph.alpha = 1.0;
    [self.lineGraph draw];
    [self.barGraph draw];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    self.graphConst.constant = 0;
    self.lineGraph.alpha = 0;
    self.barGraph.alpha = 0;
    self.array = [[NSMutableArray alloc] init];
    self.eventNumber = [[NSMutableArray alloc] init];
    self.labels = [[NSMutableArray alloc] init];
    self.barData = [[NSMutableArray alloc] init];
    self.labels = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11", @"12",@"13", @"14", @"15"];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setUpData];
    [self setUpLineGraph];
    self.barGraph.dataSource = self;
    [self.barGraph draw];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    [self.lineGraph reset];
    [self.lineGraph draw];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end