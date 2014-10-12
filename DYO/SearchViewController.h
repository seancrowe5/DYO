//
//  SearchViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "SearchResultsTableViewController.h"

@interface SearchViewController : UIViewController <SearchResultsTableViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *eduField;
@property (strong, nonatomic) NSArray  *searchResults;

- (IBAction)search:(id)sender;

@end
