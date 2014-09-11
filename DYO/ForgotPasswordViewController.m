//
//  ForgotPasswordViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/3/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)submit:(id)sender {
    //get email and put in variable
    NSString *email = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(error){
            //FAIL!
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:@"No user exists with that email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            //success! Now try and reset pass
            [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                else{
                    //Go back to home screen
                    UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Password Reset!" message:@"A reset link has been sent to your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];

                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
    }];
    
}


- (IBAction)textFieldReturn:(id)sender {
    //hides keyboard on return
    [sender resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //hides keyboard when user clicks on the background
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.passwordField isFirstResponder] && [touch view] != self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
       [super touchesBegan:touches withEvent:event];
}


@end
