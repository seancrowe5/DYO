//
//  SetupProfileViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MapKit/MapKit.h>


@interface SetupProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *educationField;
@property (strong, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) NSArray  *industry;


@property BOOL didUploadPhoto;
@property (strong, nonatomic) UITableView  *autocompleteTableView;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UITextField *areaOfStudyField;
@property (nonatomic, strong) UIImage *image;

- (IBAction)imagePicker:(id)sender;
- (IBAction)finishButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;




@end

