//
//  ProfileViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/4/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *jobTitle;
@property (strong, nonatomic) IBOutlet UITableViewCell *companyName;
@property (strong, nonatomic) IBOutlet UITableViewCell *educationName;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
