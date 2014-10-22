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
#import "HTAutocompleteManager.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate, SearchResultsTableViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *eduField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) NSArray  *searchResults;
@property (strong, nonatomic) PFGeoPoint  *userGeoPoint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
- (IBAction)eduEditingEnd:(id)sender;

-(void)allOtherFieldsDisabled:(BOOL)disable textFieldSender:(UITextField *)senderField;

- (IBAction)search:(id)sender;
- (IBAction)firstNameEditingChanged:(UITextField *)sender;
- (IBAction)lastNameEditingChanged:(UITextField *)sender;
- (IBAction)jobTitleEditingChanged:(UITextField *)sender;
- (IBAction)currentCompanyEditingChanged:(UITextField *)sender;
- (IBAction)eduEditingChanged:(UITextField *)sender;
- (IBAction)studyEditingChanged:(UITextField *)sender;
- (IBAction)industryEditingChanged:(UITextField *)sender;
- (IBAction)dismissKeyboardDrag:(id)sender;



@end
