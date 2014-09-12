//
//  SearchResultsTableViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "TableViewCell.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //////////////////
    
   
    self.userSearchResults = [NSMutableArray array];
    
    //Get all of the data into an array
    //for now, lets just get all users
    PFQuery *query = [PFUser query];
    NSArray *resultsArray = [query findObjects];
    
    for (NSArray *usersArray in resultsArray){
        //declare new USER object
        //loop through the array
        //on each iteration, we set the properties of the user class
        //add the object to the local mutable array userSearchResults
        
        User *user = [User userWithEmail:[usersArray valueForKey:@"email"]];
        user.companyName = [usersArray valueForKey:@"company"];
        user.educationLabel = [usersArray valueForKey:@"education"];
        user.jobTitle = [usersArray valueForKey:@"jobTitle"];
        user.firstName = [usersArray valueForKey:@"firstName"];
        
        //This gets the photos
        //here is what happens...if we use get data in background,
        //the view loads before the images have time to be shown, leaving empty spaces
        //i commented the backgound code out and did the process in the front...it takes a while to load
        //but for now it is good...cuz it works
        PFFile *userImageFile = [usersArray valueForKey:@"photo"];
        NSData *imageData = [userImageFile getData];
        UIImage *image = [UIImage imageWithData:imageData];
        user.profileImage = image;
        
        //commented out background process
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error) {
//                UIImage *image = [UIImage imageWithData:imageData];
//                user.profileImage = image;
//                
//            }
//        }];
        
    
        //add to local mutable array
        [self.userSearchResults addObject:user];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.userSearchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    //declare a new object of type USER
    //This takes the current row in the table view and gets the corresponding userInfo
    //from the mutable array property
    User *user = [self.userSearchResults objectAtIndex:indexPath.row];
    
    // I go get the cell and tell him the set each field text property
    //I set the text to properties in the user class
    //the information was set in the view did load for the user properties
    cell.fullNameLabel.text =   user.firstName;
    cell.jobTitle.text =        user.jobTitle;
    cell.companyLabel.text =    user.companyName;
    cell.educationLabel.text =  user.educationLabel;
    cell.profileImage.image = user.profileImage;
    
    return cell;
}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)messageButton:(id)sender {
}

- (IBAction)passButton:(id)sender {
}
@end
