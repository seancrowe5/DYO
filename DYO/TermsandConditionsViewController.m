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
@end
