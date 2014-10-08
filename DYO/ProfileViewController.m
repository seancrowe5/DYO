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
-(void)savePhoto;

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
    //if there is data for the photo...
    if(userImageFile){
        //go to parse and get the image
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [self.profileImage setImage:image];
                NSLog(@"image: %@",imageData);
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
    self.industryField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"education"]];   //industry
    self.areaOfStudyField.text = [NSString stringWithFormat:@"%@",[user valueForKey:@"areaOfStudy"]];   //industry

   
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //make sure nav shows
    [self.navigationController.navigationBar setHidden:NO];
    //set the bar to red background

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
    }
    else{
        self.jobField.enabled = NO;
        self.companyField.enabled = NO;
        self.educationField.enabled = NO;
        self.industryField.enabled = NO;
    }
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
    UIImage *newImage = [self resizeImage:self.image toWidth:200.0f andHeight:200.0f];
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


- (IBAction)logout:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:obj animated:NO];
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
        
        //Set the style of the Text Fields to indicate they are editable
        self.jobField.borderStyle = UITextBorderStyleRoundedRect;
        self.companyField.borderStyle = UITextBorderStyleRoundedRect;
        self.educationField.borderStyle = UITextBorderStyleRoundedRect;
        self.industryField.borderStyle = UITextBorderStyleRoundedRect;
        self.areaOfStudyField.borderStyle = UITextBorderStyleRoundedRect;
        
        //allow the selection on thefield
        [self areFieldsSelectable:YES];
        
        count++; //increment count to indicate that we have successfully edited the fields
        NSLog(@"Wooo you selected to edit your profile! the count in the loop is: %d",count);
    }
    

}
@end
