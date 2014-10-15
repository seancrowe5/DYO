//
//  User.h
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *jobTitle;
@property (strong,nonatomic) NSString *companyName;
@property (strong,nonatomic) NSString *educationLabel;
@property (strong,nonatomic) UIImage *profileImage;

@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) PFUser *currentUser;
@property (strong,nonatomic) PFGeoPoint *recentLocation;
@property (strong,nonatomic) NSString *userID;




- (id) initWithEmail:(NSString *)email;
+ (id) userWithEmail:(NSString *)email;


@end
