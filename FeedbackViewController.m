//
//  FeedbackViewController.m
//  DYO
//
//  Created by Sean Crowe on 10/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];
    
    
    
    self.navigationItem.title = @"FEEDBACK";
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"next-right-arrow-thin-symbol2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES; //no swipe left to navigate


    [self.textField becomeFirstResponder];
}


@end
