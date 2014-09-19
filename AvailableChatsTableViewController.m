
//
//  AvailableChatsTableViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/15/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "AvailableChatsTableViewController.h"

@interface AvailableChatsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AvailableChatsTableViewController

-(NSMutableArray *)availableChatRooms{
    //allocate initilize the mutable array
    if(!_availableChatRooms){
        _availableChatRooms = [[NSMutableArray alloc] init];
    }
    return  _availableChatRooms;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //set the table view delegate and datasource...
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Call the helper method defined below to get the updated list of messages
    [self updateAvailableChatRooms];
  
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.availableChatRooms count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *chatroom = [self.availableChatRooms objectAtIndex:indexPath.row];
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatroom[@"user1"];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        likedUser = [chatroom objectForKey:@"user2"];
    }
    else {
        likedUser = [chatroom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = likedUser[@"firstName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"availableChatToConversation" sender:indexPath];
    
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    ChatViewController *chatVC = segue.destinationViewController;
//    NSIndexPath *indexPath = sender;
//    chatVC.chatroom = [self.availableChatRooms objectAtIndex:indexPath.row];
}



-(void)updateAvailableChatRooms{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"]; //query on the chat table
    [query whereKey:@"user1" equalTo:[PFUser currentUser]]; //check if user1 field is equal to the current user
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"Chat"]; //do the oposite
    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]]; //combine the queries
    
    //[queryCombined includeKey:@"chat"]; //I think this is the message content
    [queryCombined includeKey:@"user1"]; //I think these are like SELECT statments
    [queryCombined includeKey:@"user2"];
    
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];             //if no error, then remove all previous objects from mutable array
            self.availableChatRooms = [objects mutableCopy];        //set the mutable array to the object retrieved from parse
            [self.tableView reloadData];                            //reload the data into the tableview
            
        }
        
    }];
    




    

    


}


@end
