//
//  UserAuthViewController.m
//  Done!
//
//  Created by Yongyang Nie on 5/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "UserAuthViewController.h"

@interface UserAuthViewController ()

@end

@implementation UserAuthViewController

#pragma mark - User Auth

- (IBAction)registerUser:(id)sender {
    
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    user.email = self.email.text;
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    user[@"countryCode"] = countryCode;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self animationActivityIndicator];
        self.loginB.enabled = NO;
        self.registerB.enabled = NO;
        self.registerb2.enabled = NO;
        
        if (!error) {
            [self showInitialViewController];
            NSLog(@"registered sucessfully, user: %@", [PFUser currentUser]);
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops, something went wrong" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)login:(id)sender {
    
    if (self.password.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.registerB.alpha = 0;
            self.registerBbg.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.constr.constant = 80;
                [self.view layoutIfNeeded];
            }];
            self.loginBbg.image = [UIImage imageNamed:@"button_selected.png"];
            
            self.password.alpha = 1.0;
            self.email.alpha = 1.0;
        }];
    }else{
        
        [self animationActivityIndicator];
        self.loginB.enabled = NO;
        self.registerB.enabled = NO;
        self.registerb2.enabled = NO;
        
        //login with user name and password
        [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text block:^(PFUser *user, NSError *error) {
            if (user) {
                [self showInitialViewController];
                NSLog(@"registered sucessfully, user: %@", [PFUser currentUser]);
            } else {
                //something went wrong
                NSString *errorString = [error userInfo][@"error"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops, something went wrong" message:errorString preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
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
- (IBAction)registerBegin:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.registerB.alpha = 0;
        self.registerBbg.alpha = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.constr.constant = 80;
            [self.view layoutIfNeeded];
        }];
        self.loginB.alpha = 0;
        self.registerb2.alpha = 1;
        self.loginBbg.image = [UIImage imageNamed:@"button_selected.png"];
        
        self.username.alpha = 1.0;
        self.password.alpha = 1.0;
        self.email.alpha = 1.0;
    }];
    
}

-(void)gestureActions:(UITapGestureRecognizer *)gesture{
    
    [self.email resignFirstResponder];
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
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
    self.username.delegate = self;
    self.password.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureActions:)];
    [self.background addGestureRecognizer:tap];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
