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
    //thomas add here
    
    // I will make the top navigation bar appear
    //[self.navigationController.navigationBar setHidden:NO];
    
    // I get rid of the back button text
    //self.navigationController.navigationBar.topItem.title = @"";
    
    //ABOVE IS CAUSING ISSUES FOR THE CREATE ACCOUNT PAGE TITLE..... FIX LTR
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]]; /*#f76070*/
    
}

@end
