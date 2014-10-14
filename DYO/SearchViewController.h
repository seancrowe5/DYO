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

@interface SearchViewController : UIViewController <UITextFieldDelegate, SearchResultsTableViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *eduField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) NSArray  *searchResults;
@property (strong, nonatomic) PFGeoPoint  *userGeoPoint;

- (IBAction)search:(id)sender;
- (IBAction)firstNameEditingChanged:(UITextField *)sender;
- (IBAction)lastNameEditingChanged:(UITextField *)sender;
- (IBAction)jobTitleEditingChanged:(UITextField *)sender;
- (IBAction)currentCompanyEditingChanged:(UITextField *)sender;
- (IBAction)eduEditingChanged:(UITextField *)sender;
- (IBAction)studyEditingChanged:(UITextField *)sender;
- (IBAction)industryEditingChanged:(UITextField *)sender;



@end
