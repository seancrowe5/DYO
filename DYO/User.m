//
//  User.m
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithEmail:(NSString *)email{
    //initialize using method from parten class NSObject
    self = [super init];
    
    //check if valid instance
    if( self ){
        //initialize title property
        self.email = email;
        self.firstName = nil;
        self.lastName = nil;
        self.jobTitle = nil;
        self.companyName = nil;
    }
    
    //returing the self
    return self;
}

@end
