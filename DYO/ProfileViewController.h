//
//  ProfileViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

//text fields
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *educationField;
@property (strong, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) IBOutlet UITextField *areaOfStudyField;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UITextField *placeholderField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)changePhoto:(id)sender;
- (IBAction)editProfile:(id)sender;
@end
