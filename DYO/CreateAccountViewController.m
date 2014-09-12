//
//  CreateAccountViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/3/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // I make the navigation bar appear
    [self.navigationController.navigationBar setHidden:NO];
    
    // Tho confusing as can be, I make the navigation bar transparent, though keeping items untouched
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // I set the title of the view
    self.createAccountTitle.title =@"Create a free account";
    
    // I get rid of the back button text
    self.navigationController.navigationBar.topItem.title = @"";
    
    // When the view loads, the keyboard selects this and pops up
    [self.emailField becomeFirstResponder];
    
}



- (IBAction)nextStep:(id)sender {
    
    //get the variables from text fields
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *secondPass = [self.secondPassField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([email length] == 0 || [password length]==0 || [secondPass length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter all fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    else if(![secondPass isEqualToString:password]){
        //if the second password doesn't match the first, then show error
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure your passwords match"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    else{
        //method used to create new pfuser object
        PFUser *newUser = [PFUser user];
        newUser.username = email;
        newUser.password = password;
        newUser.email = email;
        
        //create a new user and save in backend
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                //Go back to home screetn
                [self performSegueWithIdentifier:@"showProfileSetup" sender:self];
                
            }
        }];
        
    }
    
}

- (IBAction)cancelSignUp:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)textFieldReturn:(id)sender {
    //hides keyboard on return
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //hides keyboard on background touch
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.emailField isFirstResponder] && [touch view] != self.emailField) {
        [self.emailField resignFirstResponder];
    }
    if ([self.passField isFirstResponder] && [touch view] != self.passField) {
        [self.passField resignFirstResponder];
    }
    if ([self.secondPassField isFirstResponder] && [touch view] != self.secondPassField) {
        [self.secondPassField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
