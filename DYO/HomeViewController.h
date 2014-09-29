//
//  HomeViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/29/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) LocationTracker *locationTracker;
@property (nonatomic) NSTimer *locationUpdateTimer;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UITableViewCell *searchCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *profileCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *messagesCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *settingsCell;

@end
