//
//  SetupProfileViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "SetupProfileViewController.h"

@interface SetupProfileViewController () //<CLLocationManagerDelegate>
{
    NSArray *_pickerData;
    NSArray *industryArray;
    UIPickerView *pktStatePicker ;
    
    NSArray *areaOfStudyArray;
    UIPickerView *pkAreaOfStudyPicker;
    
    UIToolbar *mypickerToolbar;
    int monthClick;
}
@end

@implementation SetupProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    //Set profile image to a placeholder image so the initial launch shows something
    self.profileImage.image = [UIImage imageNamed:@"profilePlaceholder.png"];
    self.didUploadPhoto = NO;
    
    ////INDUSTRY PICKER////
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
    self.industryField.inputView =  pktStatePicker  ;
    ////end: INDUSTRY PICKER////
    
    ////AREA OF STUDY PICKER////
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
    self.areaOfStudyField.inputView =  pkAreaOfStudyPicker; //*important this makes the picker show up on selection of area field
    ////end: AREA OF STUDY PICKER////
    
    //dismiss keyboard on scroll
    self.pageScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.educationField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.educationField.autocompleteType = HTAutocompleteTypeColor;
    
    self.educationField.textAlignment = NSTextAlignmentCenter;
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.jobField.delegate = self;
    self.companyField.delegate = self;
    self.industryField.delegate = self;
    self.educationField.delegate = self;
    self.areaOfStudyField.delegate = self;

}


// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    
        [self.pageScrollView setContentOffset:CGPointMake(0,textField.center.y-70) animated:YES];
    
}

#pragma Mark - Image

- (IBAction)imagePicker:(id)sender {
    //display Action Sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose Existing",@"Take Photo",nil];
    [actionSheet showInView:self.view];
    
}

- (IBAction)finishButtonPressed:(id)sender {
    self.submitButton.enabled = NO;
    [self.activityIndicatorView startAnimating];


    //on submit get all data and put in variables
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *education = [self.educationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *study = [self.areaOfStudyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *industry = [self.industryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //story(@"industry field is: %@", industry);
    
    //validation check to see if the first three fields have something in them
    //its only three because the job and education may be dropdown fields
    if([firstName length] == 0 || [lastName length] == 0 || [company length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter all fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        self.submitButton.enabled = YES;
        [self.activityIndicatorView stopAnimating];
    }
    else{
        
        //set current user to user variable
        PFUser *user = [PFUser currentUser];
        
        //update the user class to add in information
        user[@"firstName"] = firstName;
        user[@"lastName"] = lastName;
        user[@"jobTitle"] = jobTitle;
        user[@"company"] = company;
        user[@"education"] = education;
        user[@"areaOfStudy"] = study;
        user[@"industry"] = industry;
        
        
        if(self.didUploadPhoto == YES){
            //the user uploaded his own photo
           // NSLog(@"User uploaded his photo");
            [self uploadMessage];
        }
       
        
        //save to parse in background
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                [self.activityIndicatorView stopAnimating];
                self.submitButton.enabled = YES;
            }
            else{
                //Success! Go to home screen
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"homeStoryboard"];
                self.navigationController.navigationBarHidden=NO;
                [self.navigationController pushViewController:obj animated:YES];
            }
        }];
}
    
//    //Location Services: set params and show alert to user
//    self.locationManager=[[CLLocationManager alloc] init];
//    self.locationManager.delegate=self;
//    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
//    self.locationManager.distanceFilter=10.0;
//    [self.locationManager startUpdatingLocation];
    
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //photo is passed to me with a variable called info
    //I will take that variable and set it to my image property
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //if the camera was used, lets store the image in my photo library
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    }
    
    CGFloat newSize = 100.0f; //this is the size of the square that we want

    self.profileImage.image = [self squareImageFromImage:self.image scaledToSize:newSize];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.didUploadPhoto = YES;

    return image;
}


#pragma Mark - Submit


//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *location = [locations lastObject];
//    NSLog(@"Your coordinates are: %f and %f", location.coordinate.latitude, location.coordinate.longitude);
//}


#pragma Mark - Helper Methods


-(void)uploadMessage{
    //declasre a file datatype and a filename datatype
    NSData *fileData;
    NSString *fileName;
    UIImage *newImage = self.profileImage.image; //lets try setting the new image to the image property that was set in the didfinishpickingimage method

    fileData = UIImagePNGRepresentation(newImage);
    fileName = @"image.png";
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    //save file
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Occured!"
                                                                message:@"Try sending message again"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [self.activityIndicatorView stopAnimating];
            [alertView show];
            
        }
        else{
            //success, file is on parse.com
            PFUser *currentUser = [PFUser currentUser];
            [currentUser setObject:file forKey:@"photo"];
            //save parse object in background
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Occured!"
                                                                        message:@"Try sending message again"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil, nil];
                    [self.activityIndicatorView stopAnimating];
                    [alertView show];
                }
                else{
                    //success
                    //[self reset];
                    //NSLog(@"hey");
                    
                }
                
            }];
            
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        //choose existing was pressed
        //show the library
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if(buttonIndex == 1){
        //takephoto was pressed
        //show the camera
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}


- (IBAction)textFieldReturn:(id)sender {
    //hides keyboard on return
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
        
    }
    else if(pickerView == pkAreaOfStudyPicker){
        //then set the area of study text field to the selection and resign the picker
        self.areaOfStudyField.text = [areaOfStudyArray objectAtIndex:row];
        [pkAreaOfStudyPicker resignFirstResponder]; //*trying this to see if it works
    }
    [[self view] endEditing:YES];
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
    self.educationField.textAlignment = NSTextAlignmentCenter;
}


- (IBAction)eduEditingBegan:(id)sender {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    self.educationField.leftView = paddingView;
    self.educationField.leftViewMode = UITextFieldViewModeAlways;

    self.educationField.textAlignment = NSTextAlignmentLeft;
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    self.activeField = sender;
}

- (IBAction)nextKeyPressed:(UITextField *)sender {
    NSLog(@"next key pressed");
    if (sender.tag == 0) {
        [sender resignFirstResponder];
        [self.lastNameField becomeFirstResponder];
    }
    else if (sender.tag == 1) {
        [sender resignFirstResponder];
        [self.jobField becomeFirstResponder];
    }
    else if (sender.tag == 2) {
        [sender resignFirstResponder];
        [self.companyField becomeFirstResponder];
    }
    else if (sender.tag == 3) {
        [sender resignFirstResponder];
        [self.industryField becomeFirstResponder];
    }
    else if (sender.tag == 4) {
        [sender resignFirstResponder];
        [self.educationField becomeFirstResponder];
    }
    else if (sender.tag == 5) {
        [sender resignFirstResponder];
        [self.areaOfStudyField becomeFirstResponder];
    }
    else if (sender.tag == 6) {
        [self finishButtonPressed:sender];
    }
}
@end
