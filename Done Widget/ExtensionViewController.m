//
//  ExtensionViewController.m
//  Done!
//
//  Created by Yongyang Nie on 7/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ExtensionViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface ExtensionViewController () <NCWidgetProviding>

@end

@implementation ExtensionViewController

#pragma mark - Private

-(void)setUpData{

}

-(void)setUpView{

    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    result = [sharedDefaults objectForKey:@"idAllItem"];
    
    [self setUpData];
    [self setUpView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpView];
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    NSLog(@"set up margin");
    margins.bottom = 10.0;
    margins.left = 10.00;
    return margins;
}

@end
