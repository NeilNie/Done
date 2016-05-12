//
//  TodayViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"

@interface TodayViewController ()

@end

@implementation TodayViewController

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#define kRemoveAdsProductIdentifier @"noads.toolbox"

#pragma mark - SkProduct / Payment delegates

- (IBAction)tapsRemoveAdsButton{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    if([response.products count] > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (IBAction)purchase:(SKProduct *)product{
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)restore{
    
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    areAdsRemoved = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if((SKPaymentTransactionState)transaction == SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased NoAds");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored NoAds");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                break;
        }
    }
}

- (void)doRemoveAds{
    
    areAdsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    Events *event = [allEvents objectAtIndex:indexPath.row];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [formate stringFromDate:event.date];
    cell.rippleColor = [UIColor colorWithRed:49.0/225.0 green:116.0/225.0 blue:250.0/225.0 alpha:1.0];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return allEvents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    cell.event = [allEvents objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *event = [allEvents objectAtIndex:indexPath.row];
    return [event.date dateByAddingTimeInterval:-(60 * 60 * 2)];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *event = [allEvents objectAtIndex:indexPath.row];
    // Most sports last ~3 hours, and SeatGeek doesn't provide an end time
    return event.date;
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout{
    return [NSDate date];
}

#pragma mark - Privates

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.4 animations:^{
            self.contr.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [UIView animateWithDuration:0.4 animations:^{
            self.contr.constant = [[UIScreen mainScreen] bounds].size.width;
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)longPressGesture:(UILongPressGestureRecognizer *)press{
    
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM HH:mm";
    }
    
    return dateFormatter;
}

-(void)setUpCollectionView{
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
   // [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];

}

-(void)setUpGestures{
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.table addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    press.minimumPressDuration = 1;
    [self.collectionView addGestureRecognizer:press];
    [self.collectionView addGestureRecognizer:right];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBar2.png"]];
    
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    Events *event = [EventsHelper findEarliestEventTodayWithArray:allEvents];
    self.label1.text = [NSString stringWithFormat:@"The first event of your day is %@ at %@", event.title, [[self dateFormatter] stringFromDate:event.date]];
    self.label2.text = [NSString stringWithFormat:@"There are %lu events today and you have completed %lu of them.", (unsigned long)allEvents.count, (unsigned long)[EventsHelper findCompletedEvents:allEvents withDate:[NSDate date]].count];
    
    [self.collectionView reloadData];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
    [self.table reloadData];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    
    [self setUpGestures];
    [self setUpCollectionView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
