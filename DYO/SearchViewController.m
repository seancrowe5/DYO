//
//  SearchViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController (){
    NSArray *_pickerData;
    NSArray *industryArray;
    UIPickerView *pktStatePicker ;

}

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //INDUSTRY Picker
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"testing2" ofType:@"plist"];
    // Build the array from the plist
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *array3 = [[NSMutableArray alloc]init];
    
    //loop through industry stuff
    for (NSDictionary *dict in array2) {
        [array3 addObject:[dict objectForKey:@"Industry"]];
    }
    
    //Industry Picker
    industryArray = array3;
    pktStatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 480)];
    pktStatePicker.delegate = self;
    pktStatePicker.dataSource = self;
    [pktStatePicker  setShowsSelectionIndicator:YES];
    self.industryField.inputView =  pktStatePicker  ;
    

    self.pageScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.eduField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.eduField.autocompleteType = HTAutocompleteTypeEmail;
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
    [self.activityIndicatorView stopAnimating]; //stops from spinning when user goes back to search again
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //let's send the query results over to the next page to display the results
    //results are stored in the searchResults array
    //segue is called "showSearchResults"
    
    if ([segue.identifier isEqualToString:@"showSearchResults"]) {
        NSLog(@"SEgue called");
        SearchResultsTableViewController *resultsVC = segue.destinationViewController;
        resultsVC.userSearchResults = self.searchResults;
        resultsVC.currentLocation = self.userGeoPoint;
        resultsVC.delegate = self;
 
    }
    
}


- (IBAction)search:(id)sender {

   [self.activityIndicatorView startAnimating];
    
    //get the input from user
    //only one of these should be used each search
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *education = [self.eduField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *industry = [self.eduField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *areaOfStudy = [self.eduField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Get USERs current location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userGeoPoint = geoPoint;
            NSLog(@"GeoPoint is: %@", geoPoint);
            
            //if first name field is used, then query first names of data
            //query
            PFQuery *query = [PFUser query];
            
            //if the first name contains information
            if(![firstName length] == 0){
                //use parse to search for matches
                [query whereKey:@"firstName" hasPrefix:firstName];}
            
            if(![lastName length] == 0){
                [query whereKey:@"lastName" hasPrefix:lastName];}
            
            if(![jobTitle length] == 0){
                [query whereKey:@"jobTitle" hasPrefix:jobTitle];}
            
            if(![company length] == 0){
                [query whereKey:@"company" hasPrefix:company];}
            
            if(![education length] == 0){
                [query whereKey:@"education" hasPrefix:education];}
            
            if(![industry length] == 0){
                [query whereKey:@"industry" hasPrefix:industry];}
            
            if(![areaOfStudy length] == 0){
                [query whereKey:@"areaOfStudy" hasPrefix:industry];}


            
            [query whereKey:@"lastLocation" nearGeoPoint:self.userGeoPoint withinMiles:500.0]; //5 miles
    
            self.searchResults = [query findObjects];
            
        }
        
        //calculate distance between points
        
        //print out array in console
        NSLog(@"results are: %@", _searchResults);
        [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    }];
    

}

- (IBAction)firstNameEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        NSLog(@"You have more than one character in first name field!");
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
        NSLog(@"You have else in first name field!");

    }
    
}

- (IBAction)lastNameEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }

}

- (IBAction)jobTitleEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }

}

- (IBAction)currentCompanyEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }

    
}

- (IBAction)eduEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }
}

- (IBAction)studyEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }

}

- (IBAction)industryEditingChanged:(UITextField *)sender {
    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }
}

- (IBAction)dismissKeyboardDrag:(id)sender {
    [sender resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [industryArray count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [industryArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.industryField.text = [industryArray objectAtIndex:row]; //set the label to object at row in array
    [self allOtherFieldsDisabled:YES textFieldSender:self.industryField];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15.0]];
        
    }
    tView.text = industryArray[row];
    tView.textAlignment = NSTextAlignmentCenter;
    return tView;
}

-(void)allOtherFieldsDisabled:(BOOL)disable textFieldSender:(UITextField *)senderField{
    NSLog(@"all other fields called");
    //declar the colors
    UIColor *enabledColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    UIColor *disabledColor = [UIColor whiteColor];
    
    //if the sender wants the disable all other textfields
    if(disable == YES){
        
        //if we are to disable all other fields, then disable all other fields
        switch (senderField.tag)
        
        {
            case 1:
                
                //First Name Field SElected
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.eduField.enabled = NO;
                self.areaField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
            case 2:
                
                
                //last name field selected
                self.firstNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.eduField.enabled = NO;
                self.areaField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
            case 3:
                
                //job title field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.companyField.enabled = NO;
                self.eduField.enabled = NO;
                self.areaField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
            case 4:
                
                //company field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.eduField.enabled = NO;
                self.areaField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
            case 5:
                
                //education field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.areaField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
            case 6:
                
                //industry field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.eduField.enabled = NO;
                self.areaField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.areaField.backgroundColor = disabledColor;
                
                break;
                
            case 7:
                
                //area field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.eduField.enabled = NO;
                self.industryField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                
                break;
                
        
            default:
                
                //statements
                
                break;
        }
    }
    
    if(disable == NO){
        //if we are to disable all other fields, then disable all other fields
        switch (senderField.tag)
        
        {
            case 1:
                
                //First Name Field SElected
                self.lastNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.companyField.enabled = YES;
                self.eduField.enabled = YES;
                self.areaField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 2:
                
                //last name field selected
                self.firstNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.companyField.enabled = YES;
                self.eduField.enabled = YES;
                self.areaField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 3:
                
                //job title field selected
                self.firstNameField.enabled = YES;
                self.lastNameField.enabled = YES;
                self.companyField.enabled = YES;
                self.eduField.enabled = YES;
                self.areaField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 4:
                
                //company field selected
                self.firstNameField.enabled = YES;
                self.lastNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.eduField.enabled = YES;
                self.areaField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 5:
                
                //education field selected
                self.firstNameField.enabled = YES;
                self.lastNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.companyField.enabled = YES;
                self.areaField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 6:
                
                //area of study field selected
                self.firstNameField.enabled = YES;
                self.lastNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.companyField.enabled = YES;
                self.eduField.enabled = YES;
                self.industryField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                
                break;
                
            case 7:
                
                //industry field selected
                self.firstNameField.enabled = YES;
                self.lastNameField.enabled = YES;
                self.jobField.enabled = YES;
                self.companyField.enabled = YES;
                self.eduField.enabled = YES;
                self.areaField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                self.areaField.backgroundColor = enabledColor;
                
                break;
                
                
            default:
                
                //statements
                
                break;
        }
        
    }
    


}
@end
