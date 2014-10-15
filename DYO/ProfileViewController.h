//
//  ProfileViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

//text fields
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *jobField;
@property (strong, nonatomic) IBOutlet UITextField *companyField;
@property (strong, nonatomic) IBOutlet UITextField *educationField;
@property (strong, nonatomic) IBOutlet UITextField *industryField;
@property (strong, nonatomic) IBOutlet UITextField *areaOfStudyField;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *backgroundColor;


@property (strong, nonatomic) IBOutlet UITextField *placeholderField;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)changePhoto:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)editProfileButton:(id)sender;
-(void)goodbyeKeyboard;
-(void)areFieldsSelectable:(BOOL)makeSelectable;
-(void)savePhoto;
@end
