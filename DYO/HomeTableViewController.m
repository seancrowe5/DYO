//
//  HomeTableViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/2/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()
@end

@implementation HomeTableViewController

#pragma mark - Beginning

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Associate the device with a user
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //NAv Bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]]; /*#f76070*/

   
    
    //selected cell background color
    UIView *backgroundSelectedCell = [[UIView alloc] init];
    [backgroundSelectedCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]];
    
    for (int section = 0; section < [self.tableView numberOfSections]; section++)
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++)
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            //cell.textLabel.font = [UIFont fontWithName:@"AveniBld" size:17.0f];
            [cell setSelectedBackgroundView:backgroundSelectedCell];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure"]];

        }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //nav bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;



}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; //no swipe left to navigate
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
         UIBarButtonItem *newBackButton =
         [[UIBarButtonItem alloc] initWithTitle:@" " //here is the blank back button
                                          style:UIBarButtonItemStylePlain
                                         target:nil
                                         action:nil];
         [[self navigationItem] setBackBarButtonItem:newBackButton];
 
}

#pragma mark - Table view data source




@end


