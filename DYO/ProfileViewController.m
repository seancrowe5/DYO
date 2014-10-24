//
//  ProfileViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
{
NSArray *_pickerData;
NSArray *industryArray;
UIPickerView *pktStatePicker ;
    
NSArray *areaOfStudyArray;
UIPickerView *pkAreaOfStudyPicker;
    
}
@end

@implementation ProfileViewController
int count;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];
    self.navigationItem.title = @"PROFILE";


    //display profile image from parse
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"photo"];
    
    //if there is data for the photo...
    if(userImageFile){
        //go to parse and get the image
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.profileImage setImage:image];
                //NSLog(@"image: %@",imageData);
            }
        }];
    }
    else{
        self.profileImage.image = [UIImage imageNamed:@"profilePlaceholder.png"];
    }
    
    //Display the info from parse
    self.nameField.text = [NSString stringWithFormat:@"%@ %@",[user valueForKey:@"firstName"], [user valueForKey:@"lastName"]];
    self.jobField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"jobTitle"]];          //job title
    self.companyField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"company"]];       //company
    self.educationField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"education"]];   //education
    self.industryField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"industry"]];   //industry
    self.areaOfStudyField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"areaOfStudy"]];   //industry

   
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

    
    //School Autofill
    self.educationField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.educationField.autocompleteType = HTAutocompleteTypeColor;
    
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

    //scroll delegates
    self.nameField.delegate = self;
    self.jobField.delegate = self;
    self.companyField.delegate = self;
    self.industryField.delegate = self;
    self.educationField.delegate = self;
    self.areaOfStudyField.delegate = self;


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    
    [self.pageScrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
    
}

#pragma mark - Helper Methods

-(void)goodbyeKeyboard{
    [self.jobField resignFirstResponder];
    [self.companyField resignFirstResponder];
    [self.educationField resignFirstResponder];
    [self.industryField resignFirstResponder];
    [self.areaOfStudyField resignFirstResponder];
}

-(void)areFieldsSelectable:(BOOL)makeSelectable{
    if(makeSelectable == true){
        self.jobField.enabled = YES;
        self.companyField.enabled = YES;
        self.educationField.enabled = YES;
        self.industryField.enabled = YES;
        self.areaOfStudyField.enabled = YES;
        self.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    }
    else{
        self.jobField.enabled = NO;
        self.companyField.enabled = NO;
        self.educationField.enabled = NO;
        self.industryField.enabled = NO;
        self.areaOfStudyField.enabled = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    

    self.jobField.borderStyle = UITextBorderStyleNone;
    self.jobField.backgroundColor = self.backgroundColor;
    self.companyField.borderStyle = UITextBorderStyleNone;
    self.companyField.backgroundColor = self.backgroundColor;
    self.educationField.borderStyle = UITextBorderStyleNone;
    self.educationField.backgroundColor = self.backgroundColor;
    self.industryField.borderStyle = UITextBorderStyleNone;
    self.industryField.backgroundColor = self.backgroundColor;
    self.areaOfStudyField.borderStyle = UITextBorderStyleNone;
    self.areaOfStudyField.backgroundColor = self.backgroundColor;
}

#pragma mark - IMAGE STUFF

//DICATATES WHAT HAPPENS WHEN ACTION SHEET ITEMS ARE SELECTED
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

//DISPLAYS THE ACTION SHEET AT BOTTOM OF SCREEN
- (IBAction)changePhoto:(id)sender {
    //display Action Sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose Existing",@"Take Photo",nil];
    [actionSheet showInView:self.view];
}

//METHOD TO MAKE THE IMAGE SQUARE
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
    
    return image;
}

//GETS THE IMAGE FROM THE CAMERA
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
    [self savePhoto]; //saves to parse
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)savePhoto{
    //save photo to parse
    //declasre a file datatype and a filename datatype
    NSData *fileData;
    NSString *fileName;
    
    //declare a UI image variable set it to our image property...then resize it
    UIImage *newImage = self.profileImage.image;
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
                    NSLog(@"hey");
                    
                }
                
            }];
            
        }
    }];

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
        [pickerView resignFirstResponder];
        
    }
    else if(pickerView == pkAreaOfStudyPicker){
        //then set the area of study text field to the selection and resign the picker
        self.areaOfStudyField.text = [areaOfStudyArray objectAtIndex:row];
        [pkAreaOfStudyPicker resignFirstResponder]; //*trying this to see if it works
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




- (IBAction)editProfileButton:(id)sender {
    [self.editButton setTitle:@"Save" forState:UIControlStateNormal];
    
    if(count==1){
        //You are in this loop because the user selected the save button
        
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        //style to indicate it is not editable
        self.nameField.borderStyle = UITextBorderStyleNone;
        self.jobField.borderStyle = UITextBorderStyleNone;
        self.companyField.borderStyle = UITextBorderStyleNone;
        self.educationField.borderStyle = UITextBorderStyleNone;
        self.industryField.borderStyle = UITextBorderStyleNone;
        self.areaOfStudyField.borderStyle = UITextBorderStyleNone;
        
        //outdent
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.jobField setLeftViewMode:UITextFieldViewModeAlways];
        [self.jobField setLeftView:spacerView];
        
        UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.companyField setLeftViewMode:UITextFieldViewModeAlways];
        [self.companyField setLeftView:spacerView1];
        
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.educationField setLeftViewMode:UITextFieldViewModeAlways];
        [self.educationField setLeftView:spacerView2];
        
        UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.areaOfStudyField setLeftViewMode:UITextFieldViewModeAlways];
        [self.areaOfStudyField setLeftView:spacerView3];
        
        UIView *spacerView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.industryField setLeftViewMode:UITextFieldViewModeAlways];
        [self.industryField setLeftView:spacerView4];

        //take the new values from fields and put them in variables
        NSString *jobTitle = [self.jobField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *education = [self.educationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *industry = [self.industryField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *areaOfStudy = [self.areaOfStudyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //add new info to parse for the current user
        PFUser *user = [PFUser currentUser];
        user[@"jobTitle"] = jobTitle;
        user[@"company"] = company;
        user[@"education"] = education;
        user[@"industry"] = industry;
        user[@"areaOfStudy"] = areaOfStudy;
        
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
        
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.jobField setLeftViewMode:UITextFieldViewModeAlways];
        [self.jobField setLeftView:spacerView];
        
        UIView *spacerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.companyField setLeftViewMode:UITextFieldViewModeAlways];
        [self.companyField setLeftView:spacerView1];
        
        UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.educationField setLeftViewMode:UITextFieldViewModeAlways];
        [self.educationField setLeftView:spacerView2];
        
        UIView *spacerView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.areaOfStudyField setLeftViewMode:UITextFieldViewModeAlways];
        [self.areaOfStudyField setLeftView:spacerView3];
        
        UIView *spacerView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.industryField setLeftViewMode:UITextFieldViewModeAlways];
        [self.industryField setLeftView:spacerView4];
        
        //Set the style of the Text Fields to indicate they are editable
        self.jobField.borderStyle = UITextBorderStyleRoundedRect;
        self.companyField.borderStyle = UITextBorderStyleRoundedRect;
        self.educationField.borderStyle = UITextBorderStyleRoundedRect;
        self.industryField.borderStyle = UITextBorderStyleRoundedRect;
        self.areaOfStudyField.borderStyle = UITextBorderStyleRoundedRect;
        
        UIColor *backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        
        self.jobField.backgroundColor = backgroundColor;
        //allow the selection on thefield
        [self areFieldsSelectable:YES];
        
        count++; //increment count to indicate that we have successfully edited the fields
        NSLog(@"Wooo you selected to edit your profile! the count in the loop is: %d",count);
    }
    

}

- (IBAction)eduEditingBegan:(id)sender {
    self.educationField.textAlignment = NSTextAlignmentLeft;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    self.educationField.leftView = paddingView;
    self.educationField.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)dismissKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}
@end
