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
    self.emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //set the Nav Bar
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setTitleTextAttributes: @{
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                      }];
    
    navBar.tintColor =[UIColor whiteColor]; //back button color
    [navBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]]; //logo red
    
    //small circles on secure pass field
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // I will hide the top navigation bar
    [self.navigationController.navigationBar setHidden:YES];
   
    if([PFUser currentUser]){
        //then we will segue to the home screen
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"homeStoryboard"];
        self.navigationController.navigationBarHidden=NO;
        [self.navigationController pushViewController:obj animated:NO];
    }
    else{
        //if nobody is logged in...then do nothing
    }

}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    if (textField == self.passwordField) {
        // Set to custom font if the textfield is cleared, else set it to system font
        // This is a workaround because secure text fields don't play well with custom fonts
        if (textField.text.length == 0) {
            textField.font = [UIFont fontWithName:@"Avenir" size:textField.font.pointSize];
        }
        else {
            textField.font = [UIFont systemFontOfSize:textField.font.pointSize];
        }
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
                    //then we will segue to the home screen
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"homeStoryboard"];
                    self.navigationController.navigationBarHidden=NO;
                    [self.navigationController pushViewController:obj animated:YES];

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
