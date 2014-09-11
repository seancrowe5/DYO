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


- (void)viewDidLoad
{
    [super viewDidLoad];

    //Display the name
    self.nameField.text = [NSString stringWithFormat:@"%@ %@",[[PFUser currentUser]valueForKey:@"firstName"],[[PFUser currentUser]valueForKey:@"lastName"] ];
    
    //Display the job title
    self.jobField.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"jobTitle"]];

    //Display the company
    self.companyField.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"company"]];

    
   // Display the Education
     self.educationField.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"education"]];


    // I will make the top navigation bar appear
    [self.navigationController.navigationBar setHidden:NO];}



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
        
    UIColor *color = [UIColor blueColor];
    self.placeholderField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"placeholder test" attributes:@{NSForegroundColorAttributeName: color}];
    
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
   
}
@end
