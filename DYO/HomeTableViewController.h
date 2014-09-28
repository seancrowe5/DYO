//
//  HomeTableViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/2/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"


@interface HomeTableViewController : UITableViewController
@property (strong, nonatomic) LocationTracker *locationTracker;
@property (nonatomic) NSTimer *locationUpdateTimer;
- (IBAction)logout:(id)sender;


@end
