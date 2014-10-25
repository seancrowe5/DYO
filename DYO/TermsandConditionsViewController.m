//
//  TermsandConditionsViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "TermsandConditionsViewController.h"

@interface TermsandConditionsViewController ()

@end

@implementation TermsandConditionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // I will make the top navigation bar appear
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setTitleTextAttributes: @{
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                      }];
    
    navBar.tintColor =[UIColor whiteColor]; //back button color
    [navBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]]; //logo red
    

    //self.navigationController.navigationBar.topItem.title = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationItem.title = @"TERMS AND CONDITIONS";

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
