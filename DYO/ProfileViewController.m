//
//  ProfileViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
-(void)goodbyeKeyboard;
-(void)areFieldsSelectable:(BOOL)makeSelectable;
@end

@implementation ProfileViewController
int count;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];

    //display profile image from parse
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"photo"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.profileImage setImage:image];
        }
    }];

    //Display the info from parse
    self.firstNameField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"firstName"]];   //first Name
    self.lastNameField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"lastName"]];     //Last Name
    self.jobField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"jobTitle"]];          //job title
    self.companyField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"company"]];       //company
    self.educationField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"education"]];   //education
    self.industryField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"education"]];   //industry

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - Helper Methods

-(void)goodbyeKeyboard{
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.jobField resignFirstResponder];
    [self.companyField resignFirstResponder];
    [self.educationField resignFirstResponder];
    [self.industryField resignFirstResponder];
}

-(void)areFieldsSelectable:(BOOL)makeSelectable{
    if(makeSelectable == true){
        self.firstNameField.enabled = YES;
        self.lastNameField.enabled = YES;
        self.jobField.enabled = YES;
        self.companyField.enabled = YES;
        self.educationField.enabled = YES;
        self.industryField.enabled = YES;
    }
    else{
        self.firstNameField.enabled = NO;
        self.lastNameField.enabled = NO;
        self.jobField.enabled = NO;
        self.companyField.enabled = NO;
        self.educationField.enabled = NO;
        self.industryField.enabled = NO;
    }
}

- (IBAction)editProfile:(id)sender {
    
    self.editButton.title = @"Save";
    
    if(count==1){
        //You are in this loop because the user selected the save button
        
        self.editButton.title = @"Edit";

        //style to indicate it is not editable
        self.firstNameField.borderStyle = UITextBorderStyleNone;
        self.lastNameField.borderStyle = UITextBorderStyleNone;
        self.jobField.borderStyle = UITextBorderStyleNone;
        self.companyField.borderStyle = UITextBorderStyleNone;
        self.educationField.borderStyle = UITextBorderStyleNone;
        self.industryField.borderStyle = UITextBorderStyleNone;

        //take the new values from fields and put them in variables
        NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *education = [self.educationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *industry = [self.educationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        //add new info to parse for the current user
        PFUser *user = [PFUser currentUser];
        user[@"firstName"] = firstName;
        user[@"lastName"] = lastName;
        user[@"jobTitle"] = jobTitle;
        user[@"company"] = company;
        user[@"education"] = education;
        user[@"industry"] = industry;
        
        //save to parse in background
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                //success! do sumin cray cray
                NSLog(@"Way to go Sean! You succesfully updated the user profile :)");
                [self resignFirstResponder];
            }
        }];
        //hide keyboard no matter what field is selected
        [self goodbyeKeyboard];
        
        //don't allow selection anymore on the fields
        [self areFieldsSelectable:NO];
        
        
        count=0; //show that we are finished saving
    }
    else{
        //you are here because the user selected the eidt button
        count=0;    //reset the count to 0
        
        //Set the style of the Text Fields to indicate they are editable
        self.firstNameField.borderStyle = UITextBorderStyleRoundedRect;
        self.lastNameField.borderStyle = UITextBorderStyleRoundedRect;
        self.jobField.borderStyle = UITextBorderStyleRoundedRect;
        self.companyField.borderStyle = UITextBorderStyleRoundedRect;
        self.educationField.borderStyle = UITextBorderStyleRoundedRect;
        self.industryField.borderStyle = UITextBorderStyleRoundedRect;
        
        //allow the selection on thefield
        [self areFieldsSelectable:YES];
        
        count++; //increment count to indicate that we have successfully edited the fields
        NSLog(@"Wooo you selected to edit your profile! the count in the loop is: %d",count);
    }
    

}
@end
