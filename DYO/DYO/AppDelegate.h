//
//  AppDelegate.h
//  DYO
//
//  Created by Sean Crowe on 9/2/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTracker.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LocationTracker *locationTracker;
@property (nonatomic) NSTimer *locationUpdateTimer;

@end
