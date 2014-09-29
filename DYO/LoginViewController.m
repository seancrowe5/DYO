//
//  LoginViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/2/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.emailField becomeFirstResponder];
    self.emailField.delegate = self;
    //self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //if a user exists...
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // I will hide the top navigation bar
    [self.navigationController.navigationBar setHidden:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    /*
    UIColor *color = [UIColor darkTextColor];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];  */

    if([PFUser currentUser]){
        //then we will segue to the home screen
//        [self performSegueWithIdentifier:@"showHome" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"homeStoryboard"];
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:obj animated:NO];
    }
    else{
        //if nobody is logged in...then do nothing
    }

}


- (IBAction)login:(id)sender {

    
    //get info from the text fields
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    //if nothing is entered in username OR pass, then show alert
    if([email length] == 0 || [password length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter all fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    else{
        //do something in the background with parse. I think it logs the user in
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                [self performSegueWithIdentifier:@"showHome" sender:self];
    
            }}];
    }
}
    
- (IBAction)textFieldReturn:(id)sender {
    //hides keyboard on return
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.emailField isFirstResponder] && [touch view] != self.emailField) {
        [self.emailField resignFirstResponder];
    }
    if ([self.passwordField isFirstResponder] && [touch view] != self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
