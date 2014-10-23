//
//  ViewController.m
//  DYO
//
//  Created by Sean Crowe on 10/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];
    
    
    
    self.navigationItem.title = @"SETTINGS";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;


}


- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *obj=[storyboard  instantiateViewControllerWithIdentifier:@"loginView"];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:NO];
    
}
@end
