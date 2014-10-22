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
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //NAv Bar
    [self.navigationController.navigationBar setHidden:YES];
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
            cell.textLabel.font = [UIFont fontWithName:@"AveniBld" size:17.0f];
            [cell setSelectedBackgroundView:backgroundSelectedCell];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosure"]];

        }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //nav bar
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end


