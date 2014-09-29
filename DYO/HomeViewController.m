//
//  HomeViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/29/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // I will make the top navigation bar appear
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    
    
    
    //ADDED LOCATION STUFF
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    
    //LOCATION CODE
    NSTimeInterval time = 60.0;
    self.locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
    
    //END LOCATION CODE

}



@end
