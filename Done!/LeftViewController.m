//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "MainViewController.h"

@interface LeftViewController ()

@property (nonatomic, assign) CGPoint circleTransitionStartPoint;
@property (nonatomic, assign) CGRect transitionCellRect;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // -----

    _titlesArray = @[@"Done - Task Manager",
                     @"",
                     @"Today",
                     @"Tasks",
                     @"Calendar",
                     @"Preference",];

    // -----
//    self.presentDismissAnimationController = [[RZRectZoomAnimationController alloc] init];
//    [self.presentDismissAnimationController setRectZoomDelegate:self];
//    self.circleTransitionStartPoint = CGPointZero;
//    self.transitionCellRect = CGRectZero;
//    [[RZTransitionsManager shared] setAnimationController:self.presentDismissAnimationController
//                                       fromViewController:[self class]
//                                                forAction:RZTransitionAction_PresentDismiss];
//    [self setTransitioningDelegate:[RZTransitionsManager shared]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(44.f, 0.f, 44.f, 0.f);
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.separatorView.hidden = !(indexPath.row != 0 && indexPath.row != 1 && indexPath.row != _titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1);

    cell.tintColor = _tintColor;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) return 22.f;
    else return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    UINavigationController *today = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    UINavigationController *projects = [self.storyboard instantiateViewControllerWithIdentifier:@"Tasks"];
    UINavigationController *preference = [self.storyboard instantiateViewControllerWithIdentifier:@"Preference"];
    UINavigationController *calendar = [self.storyboard instantiateViewControllerWithIdentifier:@"Calendar"];
    MainViewController *mainViewController = [self.storyboard instantiateInitialViewController];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    switch (indexPath.row) {
        case 2:
            mainViewController.rootViewController = today;
            window.rootViewController = mainViewController;
            [UIView transitionWithView:window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            break;
        case 3:
            
            mainViewController.rootViewController = projects;
            window.rootViewController = mainViewController;
            [UIView transitionWithView:window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            break;
        case 4:
            mainViewController.rootViewController = calendar;
            window.rootViewController = mainViewController;
            [UIView transitionWithView:window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            break;
        case 5:
            mainViewController.rootViewController = preference;
            window.rootViewController = mainViewController;
            [UIView transitionWithView:window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            break;
            
        default:
            break;
    }
    [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideBelow type:0];
}

//- (UIViewController *)nextViewControllerForInteractor:(id<RZTranitionInteractionController>)interactor
//{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *today = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
//    return today;
//}

#pragma mark - RZRectZoomAnimationDelegate

- (CGRect)rectZoomPosition
{
    return self.view.frame;
}

#pragma mark - RZCirclePushAnimationDelegate

- (CGPoint)circleCenter
{
    return self.circleTransitionStartPoint;
}

- (CGFloat)circleStartingRadius
{
    return 30.0f;
}

@end
