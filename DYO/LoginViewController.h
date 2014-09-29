//
//  LoginViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/2/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>



@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic, assign) id currentResponder;
@property (weak, nonatomic) IBOutlet UINavigationItem *loginTitleBar;

- (IBAction)login:(id)sender;

@end
