//
//  ViewController.m
//  DYO
//
//  Created by Sean Crowe on 10/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ViewController.h"
#import <HockeySDK/HockeySDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];
    
    
    
    self.navigationItem.title = @"SETTINGS";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;


}


- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *obj=[storyboard  instantiateViewControllerWithIdentifier:@"loginView"];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:NO];
    
}

- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"DYO Feedback";
    // Email Content
    NSString *messageBody = @"Let us know any comments, concerns, or bugs you may find!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"hanyul@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
