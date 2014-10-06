//
//  SearchViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setHidden:NO];
    [navBar setTitleTextAttributes: @{
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Regular" size:17.0f],
                                      }];
    
    navBar.tintColor =[UIColor whiteColor]; //back button color
    navBar.backgroundColor = [UIColor colorWithRed:0.929 green:0.243 blue:0.31 alpha:1]; /*#f76070*/
}


/*

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search:(id)sender {
    
    //get the input from user
    //only one of these should be used each search
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *education = [self.eduField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    //if first name field is used, then query first names of data
        //query
    PFQuery *query = [PFUser query];

    //if the first name contains information
    if(![firstName length] == 0){
        //use parse to search for matches
        [query whereKey:@"firstName" hasPrefix:firstName]; }
        
    if(![lastName length] == 0){
        [query whereKey:@"lastName" hasPrefix:lastName];}

    if(![jobTitle length] == 0){
        [query whereKey:@"jobTitle" hasPrefix:jobTitle];}
    
    if(![company length] == 0){
        [query whereKey:@"company" hasPrefix:company];}
    
    if(![education length] == 0){
        [query whereKey:@"education" hasPrefix:education];}
    
    NSArray *searchResults = [query findObjects];
        
    //print out array in console
    NSLog(@"results are: %@", searchResults);
    
   
}

//when user selects a field, all others are inactive
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
@end
