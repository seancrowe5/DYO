//
//  CreateAccountViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/3/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface CreateAccountViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UITextField *secondPassField;
@property (weak, nonatomic) IBOutlet UINavigationItem *createAccountTitle;
@property (weak, nonatomic) IBOutlet UITextView *createAccountSubTitle;

- (IBAction)nextStep:(id)sender;
- (IBAction)cancelSignUp:(id)sender;
- (IBAction)nextKeyPressed:(UITextField *)sender;


@end
