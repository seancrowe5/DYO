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
    int monthClick;
    NSArray *industryArray;
    UIPickerView *pktStatePicker ;
    UIToolbar *mypickerToolbar;

    NSArray *collegeArray;
    UIPickerView *pktCollegePicker ;


}
@end

@implementation SetupProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // I will make the top navigation bar appear
    //[self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.hidesBackButton = YES;
    
    //Set profile image to a placeholder image so the initial launch shows something
    
    self.profileImage.image = [UIImage imageNamed:@"profilePlaceholder.png"];
    self.didUploadPhoto = NO;
    
    
    //get industry plist
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
    
    
    //college picker
    //get industry plist
    NSString *pathCollege = [[NSBundle mainBundle] pathForResource:
                      @"CollegeData" ofType:@"plist"];
    // Build the array from the plist
    NSMutableArray *arrayCollege = [[NSMutableArray alloc] initWithContentsOfFile:pathCollege];
    NSMutableArray *arrayCollege2 = [[NSMutableArray alloc]init];
    
    //loop through industry stuff
    for (NSDictionary *dict in arrayCollege) {
        [arrayCollege2 addObject:[dict objectForKey:@"College"]];
    }
    
    //College Picker
    collegeArray = arrayCollege2;
    pktCollegePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 480)];
    pktCollegePicker.delegate = self;
    pktCollegePicker.dataSource = self;
    [pktCollegePicker  setShowsSelectionIndicator:YES];
    self.educationField.inputView =  pktCollegePicker  ;
    
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
    
    //declare a UI image variable set it to our image property...then resize it
    UIImage *newImage = [self resizeImage:self.image toWidth:100.0f andHeight:100.0f];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //hides keyboard on background touch
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.firstNameField isFirstResponder] && [touch view] != self.firstNameField) {
        [self.firstNameField resignFirstResponder];
    }
    if ([self.lastNameField isFirstResponder] && [touch view] != self.lastNameField) {
        [self.lastNameField resignFirstResponder];
    }
    if ([self.jobField isFirstResponder] && [touch view] != self.jobField) {
        [self.jobField resignFirstResponder];
    }
    if ([self.companyField isFirstResponder] && [touch view] != self.companyField) {
        [self.companyField resignFirstResponder];
    }
    if ([self.educationField isFirstResponder] && [touch view] != self.educationField) {
        [self.educationField resignFirstResponder];
        pktCollegePicker.hidden = YES;
    }
    if ([self.areaOfStudyField isFirstResponder] && [touch view] != self.areaOfStudyField) {
        [self.areaOfStudyField resignFirstResponder];
    }
    if ([self.industryField isFirstResponder] && [touch view] != self.industryField) {
        [self.industryField resignFirstResponder];
        pktStatePicker.hidden = YES;
    }
    [super touchesBegan:touches withEvent:event];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if([pickerView isEqual: pktStatePicker]){
        // return the appropriate number of components, for instance
        return [industryArray count];
        
    }
    
    if([pickerView isEqual: pktCollegePicker]){
        // return the appropriate number of components, for instance
        return [collegeArray count];
    }
    
    return [industryArray count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if([pickerView isEqual: pktStatePicker]){
        return [industryArray objectAtIndex:row];
    }
    
    if([pickerView isEqual: pktCollegePicker]){
        return [collegeArray objectAtIndex:row];
    }

    
    return [industryArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if([pickerView isEqual: pktStatePicker]){
        self.industryField.text = [industryArray objectAtIndex:row];
    }
    
    if([pickerView isEqual: pktCollegePicker]){
        self.educationField.text = [collegeArray objectAtIndex:row];
    }
    
}


@end
