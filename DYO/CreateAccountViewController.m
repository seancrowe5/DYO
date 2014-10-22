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

    [self.navigationController.navigationBar setHidden:YES]; // I make the navigation bar appear
    self.createAccountTitle.title =@"Create a free account"; // I set the title of the view
    [self.emailField becomeFirstResponder]; // When the view loads, the keyboard selects this and pops up
    //small circles on secure pass field
    [self.passField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.secondPassField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [self.navigationController.navigationBar setHidden:YES]; // I make sure the navigation bar appear
    [self.emailField becomeFirstResponder]; // When the view loads, the keyboard selects this and pops up
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //no swipe left to navigate

}

- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    
    if ( (textField == self.passField) || (textField ==self.secondPassField) ) {
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



- (IBAction)nextStep:(id)sender {
    
    //get the variables from text fields
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *secondPass = [self.secondPassField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //logic to check password has some capitals and numbers
    int occurrenceCapital = 0;
    int occurenceNumbers = 0;
    for (int i = 0; i < [password length]; i++) {
        if([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[password characterAtIndex:i]])
            occurrenceCapital++;
        if([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[password characterAtIndex:i]])
            occurenceNumbers++;
    }
    
    //NSLog(@"There are: %d capital letters", occurrenceCapital);
    //NSLog(@"There are: %d numbers", occurenceNumbers);

    
    //check if email, pas, and second pass are filled in
    if([email length] == 0 || [password length]==0 || [secondPass length]==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter all fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    else if((occurenceNumbers < 1) || (occurrenceCapital < 1) || ([password length] < 6)){
        //show alert if password doens't contain numbers or capital letter or have enough characters
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure your password is at least 6 characters, has a capital letter and a number"
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



- (IBAction)nextKeyPressed:(UITextField *)sender {
    NSLog(@"next key pressed");
    if (sender.tag == 0) {
        [sender resignFirstResponder];
        [self.passField becomeFirstResponder];
    }
    else if (sender.tag == 1) {
        [sender resignFirstResponder];
        [self.secondPassField becomeFirstResponder];
    }
    else if (sender.tag == 2) {
        [self nextStep:
         sender];
    }
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
