//
//  FeedbackViewController.h
//  DYO
//
//  Created by Sean Crowe on 10/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HockeySDK/HockeySDK.h>
#import <MessageUI/MessageUI.h>



@interface FeedbackViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textField;

@end
