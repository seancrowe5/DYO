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
    //Get user info from Parse.com
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFUser query];
   [query whereKey:@"objectId" equalTo:user.objectId];
    NSArray *userInfo = [query findObjects];
    NSString *name = [userInfo valueForKey:@"firstName"];
    //[self.nameLabel setText:name];
    
   
    
 
    
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

@end
