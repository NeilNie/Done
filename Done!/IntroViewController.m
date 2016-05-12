//
//  IntroViewController.m
//  
//
//  Created by Yongyang Nie on 5/8/16.
//
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

-(void)showIntroView{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"This is page 1";
    page1.bgImage = [UIImage imageNamed:@"Screenshot01.png"];
    page1.desc = @"";
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"";
    page2.bgImage = [UIImage imageNamed:@"Screenshot02.png"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 2";
    page3.desc = @"";
    page3.bgImage = [UIImage imageNamed:@"Screenshot01.png"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.1];
}

- (void)viewDidLoad {
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
