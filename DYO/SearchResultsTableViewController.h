//
//  SearchResultsTableViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface SearchResultsTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *userSearchResults;

- (IBAction)messageButton:(id)sender;
- (IBAction)passButton:(id)sender;
@end
