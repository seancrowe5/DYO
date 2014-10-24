//
//  ProfileViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HTAutocompleteManager.h"

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

//text fields
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet HTAutocompleteTextField *educationField;
@property (strong, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) IBOutlet UITextField *areaOfStudyField;
@property (strong, nonatomic) UITextField *activeField;

- (IBAction)dismissKeyboard:(UITextField *)sender;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *theProfileImage;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;

- (IBAction)eduEditingBegan:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UITextField *placeholderField;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) UIImageView *profileImage;
- (IBAction)changePhoto:(id)sender;
- (IBAction)editProfileButton:(id)sender;
-(void)goodbyeKeyboard;
-(void)areFieldsSelectable:(BOOL)makeSelectable;
-(void)savePhoto;
@end
