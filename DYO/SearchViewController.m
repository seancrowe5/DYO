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

    
    NSArray *areaOfStudyArray;
    UIPickerView *pkAreaOfStudyPicker;
}

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /////////////////////////////////
    /////////////////////////////////
    ////Industry Picker Setup////////
    /////////////////////////////////
    /////////////////////////////////
    
    //Go get dataa and save in some arrays
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"testing2" ofType:@"plist"];
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSMutableArray *array3 = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in array2) {
        [array3 addObject:[dict objectForKey:@"Industry"]];
    }
    
    industryArray = array3;
    pktStatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 480)];
    pktStatePicker.delegate = self;
    pktStatePicker.dataSource = self;
    [pktStatePicker  setShowsSelectionIndicator:YES];
    self.industryField.inputView =  pktStatePicker ;
    
    // Create done button in UIPickerView
    UIToolbar *mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
    mypickerToolbar.barStyle = UIBarStyleDefault;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [mypickerToolbar setItems:barItems animated:YES];
    self.industryField.inputAccessoryView = mypickerToolbar;
    
    
    /////////////////////////////////
    /////////////////////////////////
    ////Area of Study Picker ////////
    /////////////////////////////////
    /////////////////////////////////
    
    //go get some data and put in arrays
    NSString *path2 = [[NSBundle mainBundle] pathForResource:
                       @"areaOfStudy" ofType:@"plist"]; //gets the file
    NSMutableArray *array4 = [[NSMutableArray alloc] initWithContentsOfFile:path2]; //build the array from fil
    NSMutableArray *array5 = [[NSMutableArray alloc]init]; //temporary array for looping
    NSLog(@"array 4 is: %@", array4);
    for (NSDictionary *dict in array4) {
        [array5 addObject:[dict objectForKey:@"Area of Study"]]; //each area of study line added to array5
    }
    areaOfStudyArray = array5;
    pkAreaOfStudyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 480)];
    pkAreaOfStudyPicker.delegate = self;
    pkAreaOfStudyPicker.dataSource = self;
    [pkAreaOfStudyPicker  setShowsSelectionIndicator:YES];
    self.areaField.inputView =  pkAreaOfStudyPicker; //*important this makes the picker show up on selection of area field
    self.areaField.inputAccessoryView = mypickerToolbar;
    
    
    
    //dismiss keyboard on drag
    self.pageScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.eduField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.eduField.autocompleteType = HTAutocompleteTypeColor;
    self.eduField.textAlignment = NSTextAlignmentCenter;
   

   //for the scroll view to change when field selected
    self.lastNameField.delegate = self;
    self.jobField.delegate = self;
    self.companyField.delegate = self;
    self.industryField.delegate = self;
    self.eduField.delegate = self;
    self.firstNameField.delegate = self;
    self.areaField.delegate = self;
    
   
   
}


-(void)viewWillAppear:(BOOL)animated{
   // UINavigationBar *navBar = self.navigationController.navigationBar;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];

    

    
    self.navigationItem.title = @"SEARCH";
    [self.activityIndicatorView stopAnimating]; //stops from spinning when user goes back to search again
    
}

-(void)pickerDoneClicked{
    [[self view] endEditing:YES];
}
// called when textField is selected.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    if(self.activeField != self.firstNameField || self.activeField != self.areaField){
    [self.pageScrollView setContentOffset:CGPointMake(0,textField.center.y-70) animated:YES];
    }
    
    if(self.activeField == self.industryField || self.activeField == self.areaField){
        
        pktStatePicker.hidden = NO;
       pkAreaOfStudyPicker.hidden = NO;
       
        
    }
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
    NSString *industry = [self.industryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *areaOfStudy = [self.areaField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"eductation chosen: %@", education);
    
    //Get USERs current location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userGeoPoint = geoPoint;
            PFUser *currentUser = [PFUser currentUser];
            currentUser[@"lastLocation"] = geoPoint;
            [currentUser save];
            NSLog(@"GeoPoint is: %@", geoPoint);
            
            //if first name field is used, then query first names of data
            //query
            PFQuery *query = [PFUser query];
            
            //if the first name contains information
            if(![firstName length] == 0){
                //use parse to search for matches
                [query whereKey:@"firstName" matchesRegex:firstName modifiers:@"i"];}
            if(![lastName length] == 0){
                [query whereKey:@"lastName" matchesRegex:lastName modifiers:@"i"];;}
            
            if(![jobTitle length] == 0){
                [query whereKey:@"jobTitle" matchesRegex:jobTitle modifiers:@"i"];}
            
            if(![company length] == 0){
                [query whereKey:@"company" matchesRegex:company modifiers:@"i"];}
            
            if(![education length] == 0){
                [query whereKey:@"education" matchesRegex:education modifiers:@"i"];}
            
            if(![industry length] == 0){
                [query whereKey:@"industry" matchesRegex:industry modifiers:@"i"];}
            
            if(![areaOfStudy length] == 0){
                [query whereKey:@"areaOfStudy" matchesRegex:areaOfStudy modifiers:@"i"];}

            [query whereKey:@"lastLocation" nearGeoPoint:self.userGeoPoint withinMiles:50000.0]; //Get current loc and search within50000 miles
            [query whereKey:@"objectId" notEqualTo:currentUser.objectId]; //make sure we exlude the current user from search results
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
    self.eduField.textAlignment = NSTextAlignmentLeft;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    self.eduField.leftView = paddingView;
    self.eduField.leftViewMode = UITextFieldViewModeAlways;
    

    if(sender.text.length >= 1){
        //if there is 1 or more characters in the field, then disable all others
        [self allOtherFieldsDisabled:YES textFieldSender:sender];
        
    }
    else{
        //if there are zero characters, then
        [self allOtherFieldsDisabled:NO textFieldSender:sender];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    [self allOtherFieldsDisabled:NO textFieldSender:textField];
    //This is where you show the picker AFTER it has been cleared
    pktStatePicker.hidden = NO;
    pkAreaOfStudyPicker.hidden = NO;
    
    
    
    return YES;
}

- (IBAction)dismissKeyboardDrag:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual:pktStatePicker]){
        //then return the number of rows in industry array
        return [industryArray count];
    }
    else if(pickerView == pkAreaOfStudyPicker){
        //then return the number of rows in area of study array
        return [areaOfStudyArray count];
    }
    else{
        //else return something, just in case
        return [industryArray count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == pktStatePicker){
        //then return the row of industry array
        return [industryArray objectAtIndex:row];
    }
    else if(pickerView == pkAreaOfStudyPicker){
        //then return the row of area of study array
        return [areaOfStudyArray objectAtIndex:row];
    }
    else{
        //else return something, just in case
        return [industryArray objectAtIndex:row];
        
    }

}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == pktStatePicker){
        //then set the industry text field to the selection and resign the picker
        self.industryField.text = [industryArray objectAtIndex:row];
        [self allOtherFieldsDisabled:YES textFieldSender:self.industryField];
       
        


    }
    else if(pickerView == pkAreaOfStudyPicker){
        //then set the area of study text field to the selection and resign the picker
        self.areaField.text = [areaOfStudyArray objectAtIndex:row];
        [self allOtherFieldsDisabled:YES textFieldSender:self.areaField];
        
    }
    
   
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"Avenir" size:15.0]]; //font size for picker views
        
    }
    
    if([pickerView isEqual: pktStatePicker]){
        tView.text = industryArray[row];
    }
    if([pickerView isEqual:pkAreaOfStudyPicker]){
        tView.text = areaOfStudyArray[row];
    }
    
    tView.textAlignment = NSTextAlignmentCenter;
    return tView;
}

- (IBAction)eduEditingEnd:(id)sender {
    self.eduField.textAlignment = NSTextAlignmentCenter;
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
                
                //area of study field selected
                self.firstNameField.enabled = NO;
                self.lastNameField.enabled = NO;
                self.jobField.enabled = NO;
                self.companyField.enabled = NO;
                self.industryField.enabled = NO;
                self.eduField.enabled = NO;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = disabledColor;
                self.lastNameField.backgroundColor = disabledColor;
                self.jobField.backgroundColor = disabledColor;
                self.companyField.backgroundColor = disabledColor;
                self.industryField.backgroundColor = disabledColor;
                self.eduField.backgroundColor = disabledColor;
                
                break;
                
            case 7:
                
                //area field selected
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
                self.industryField.enabled = YES;
                self.eduField.enabled = YES;
                
                //make background change to disabled color
                self.firstNameField.backgroundColor = enabledColor;
                self.lastNameField.backgroundColor = enabledColor;
                self.jobField.backgroundColor = enabledColor;
                self.companyField.backgroundColor = enabledColor;
                self.industryField.backgroundColor = enabledColor;
                self.eduField.backgroundColor = enabledColor;
                
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
