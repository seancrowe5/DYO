//
//  ViewController.h
//  DYO
//
//  Created by Sean Crowe on 10/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)logoutPressed:(id)sender;
- (IBAction)showEmail:(id)sender;


@end
