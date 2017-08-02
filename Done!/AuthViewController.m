//
//  UserAuthViewController.m
//  Done!
//
//  Created by Yongyang Nie on 5/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

#pragma mark - Private

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

#pragma mark - IBAction

- (IBAction)authenticateUser:(id)sender {
    
    
}

#pragma mark - Private Helpers

-(void)showInitialViewController{
    
    //hey, we are in, let's show the view controller.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    window.rootViewController = navigationController;
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
}

-(void)animationActivityIndicator{
    
    self.activityIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
    self.activityIndicator.color = [UIColor whiteColor];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

#pragma mark - MDTextField Delegate

-(BOOL)textFieldShouldReturn:(MDTextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.doneButton.layer.cornerRadius = 5.0;
    self.doneButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.doneButton.layer.shadowRadius = 3.0;
    self.doneButton.layer.shadowOffset = CGSizeMake(5.0, 5.0);
    self.doneButton.layer.masksToBounds = YES;
    
    if (self.view.frame.size.width == 320) {
        self.iconLeft.constant = 35;
        self.iconRight.constant = 35;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
