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
    
    // I will make the top navigation bar appear
    [self.navigationController.navigationBar setHidden:NO];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]]; /*#f76070*/
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    //sets the back button to white
    [self.navigationItem.backBarButtonItem setBackgroundImage:[UIImage imageNamed:@"backbtn.ico"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //make back button white
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
