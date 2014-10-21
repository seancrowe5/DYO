//
//  ForgotPasswordViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/3/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ForgotPasswordViewController : UIViewController
- (IBAction)submit:(id)sender;
- (IBAction)cancelButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@end
