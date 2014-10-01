//
//  ProfileViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()


@end

@implementation ProfileViewController
int count;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];

    //display image
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"photo"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [self.profileImage setImage:image];
        }
    }];

    //Display the name
    self.nameField.text = [NSString stringWithFormat:@"%@ %@",[user valueForKey:@"firstName"],[user valueForKey:@"lastName"] ];
    
    //Display the job title
    self.jobField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"jobTitle"]];

    //Display the company
    self.companyField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"company"]];

    
   // Display the Education
     self.educationField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"education"]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editProfile:(id)sender {
    
    self.editButton.title = @"Save";
    
    if(count==1){
        //You are in this loop because the user selected the save button
        
        self.editButton.title = @"Edit";

        //change border style to indicate it is editable
        self.nameField.borderStyle = UITextBorderStyleNone;
        self.jobField.borderStyle = UITextBorderStyleNone;
        self.companyField.borderStyle = UITextBorderStyleNone;
        self.educationField.borderStyle = UITextBorderStyleNone;
        
        //take the values from fields and put them in variables
        NSString *firstName = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *education = [self.educationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //add new info to parse for the current user
        PFUser *user = [PFUser currentUser];
        user[@"firstName"] = firstName;
        user[@"jobTitle"] = jobTitle;
        user[@"company"] = company;
        user[@"education"] = education;
        
        //save to parse in background
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                //success! do sumin cray cray
                NSLog(@"you rock");
                [self resignFirstResponder];
            }
        }];
        [self.nameField resignFirstResponder];
        count=0;

    }
    else{
        //you are here because the user selected the eidt button
        count=0;
               //set the ui image
        //set the border of the text field to indicate its editable
        self.nameField.borderStyle = UITextBorderStyleRoundedRect;
        self.jobField.borderStyle = UITextBorderStyleRoundedRect;
        self.companyField.borderStyle = UITextBorderStyleRoundedRect;
        self.educationField.borderStyle = UITextBorderStyleRoundedRect;
        
        //allow the keyboard to show if user selects field
        self.nameField.enabled = YES;
        self.jobField.enabled = YES;
        self.companyField.enabled = YES;
        self.educationField.enabled = YES;
        count++;
        NSLog(@"count iinside: %d",count);

        
    }
    
}
@end
