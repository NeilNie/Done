//
//  TipsViewController.m
//  Done!
//
//  Created by Yongyang Nie on 5/8/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    if (self.navigationController.parentViewController != nil) {
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self performSegueWithIdentifier:@"idFinishIntro" sender:nil];
    }
}

-(void)showIntroView{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Swipe left to create a new project";
    page1.titlePositionY = 120;
    page1.titleColor = [UIColor whiteColor];
    page1.bgImage = [UIImage imageNamed:@"screen_shot_1.png"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Click return after entering the title.";
    page2.titlePositionY = 120;
    page2.titleColor = [UIColor whiteColor];
    page2.desc = @"";
    page2.bgImage = [UIImage imageNamed:@"screen_shot_2.png"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Swipe right on an event to mark it as important";
    page4.titlePositionY = 120;
    page4.titleColor = [UIColor whiteColor];
    page4.desc = @"";
    page4.bgImage = [UIImage imageNamed:@"screen_shot_4.png"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"Swipe up to see list of events in a certain day.";
    page5.titlePositionY = 120;
    page5.titleColor = [UIColor whiteColor];
    page5.bgImage = [UIImage imageNamed:@"screen_shot_5.png"];
    
    EAIntroPage *page6 = [EAIntroPage page];
    page6.title = @"Swipe down to create a new event.";
    page6.titlePositionY = 120;
    page6.titleColor = [UIColor whiteColor];
    page6.bgImage = [UIImage imageNamed:@"screen_shot_7.png"];
    
    EAIntroPage *page7 = [EAIntroPage page];
    page7.title = @"Welcome to Done! Let's get things done.";
    page7.titleFont = [UIFont systemFontOfSize:40 weight:UIFontWeightLight];
    page7.titlePositionY = 200;
    page7.titleColor = [UIColor whiteColor];
    page7.bgImage = [UIImage imageNamed:@"bg5@2x.png"];
    
    EAIntroPage *page8 = [EAIntroPage page];
    page8.title = @"You can see all of your projects and events on your apple watch. The data will sync automatically.";
    page6.titlePositionY = 150;
    page8.titleColor = [UIColor whiteColor];
    page8.bgImage = [UIImage imageNamed:@"appWScr-1.png"];
    
    EAIntroPage *page9 = [EAIntroPage page];
    page9.title = @"You can also customize your watch face to see the recent events. Everything is at a glance.";
    page9.titlePositionY = 150;
    page9.titleColor = [UIColor whiteColor];
    page9.bgImage = [UIImage imageNamed:@"appWScr-2.png"];
    
    EAIntroPage *page10 = [EAIntroPage page];
    page10.title = @"With glance, you can see the upcoming event and date, so you won't miss anything!";
    page10.titlePositionY = 150;
    page10.titleColor = [UIColor whiteColor];
    page10.bgImage = [UIImage imageNamed:@"appWScr-3.png"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.frame andPages:@[page7, page1, page6,page2, page4, page5, page8, page9, page10]];
    intro.skipButton.hidden = YES;
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.3];
}

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = YES;
    
    [FIRAnalytics logEventWithName:kFIREventViewItem parameters:@{kFIRParameterContentType:@"introView",
                                                                  kFIRParameterValue:@"1",
                                                                  kFIRParameterItemID:@"A01"
                                                                  }];
    [self showIntroView];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
