
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
    //i want to test syncing
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set the table view delegate and datasource...
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationController.navigationBar setHidden:NO];

    
    //Call the helper method defined below to get the updated list of chatrooms
    [self updateAvailableChatRooms];
    
    self.listOfAvatars = [[NSMutableArray alloc] init];
  
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
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
    
    PFObject *chatroom = [self.availableChatRooms objectAtIndex:indexPath.row]; //accessing chatroom
    PFUser *selectedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatroom[@"user1"];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        selectedUser = [chatroom objectForKey:@"user2"];
    }
    else {
        selectedUser = [chatroom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = selectedUser[@"firstName"];
    
    //Images in Cells//
    
    //cell.imageview.image = placeholderImage;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    PFFile *userImageFile = [selectedUser valueForKey:@"photo"]; //declare a Parse file datatype obect and store the file
    
    //GET DATA IN BACKGROUND ???? //
    ///////////////////////////////
    NSData *imageData = [userImageFile getData]; //put image in NSData object
    self.userImage = [UIImage imageWithData:imageData]; //asign property userImage the image from data
    [self.listOfAvatars addObject:self.userImage];
    cell.imageView.image =[self.listOfAvatars objectAtIndex:indexPath.row]; //display the userImage property
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
   // NSLog(@"PHOTO: %ld",(long)indexPath.row);
    
    return cell;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* 1. You click a person to chat with
     * 2. I create an instance (*chatVC) of the ChatView Controller and set it equal to the desitinationViewController (ChatViewController)
     * 3. I can now access the properties of the VC. So I set the 'chatRoom' property to the object in the current array 'availableChatRooms' at the index path chosen
     */
    
    if ([segue.identifier isEqualToString:@"availableChatsToMessages"]) {
        //UINavigationController *nc = segue.destinationViewController;
        //JSQDemoViewController *vc = (JSQDemoViewController *)nc.topViewController;
        //vc.delegateModal = self;
        

//        JSQDemoViewController *matchVC = segue.destinationViewController;
//        NSIndexPath *indexPath = sender;
//        matchVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
//        matchVC.delegate = self;
//        NSLog(@"chatroom: %@",self.availableChatRooms);
        
        ChatView *matchVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        matchVC.chatRoomObject = [self.availableChatRooms objectAtIndex:indexPath.row];
        matchVC.selectedUserImage = self.userImage;
        matchVC.delegate = self;
        matchVC.isFirstMessage = false;
        

    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"availableChatsToMessages" sender:indexPath];
    
    
}

#pragma mark - Helper

-(void)updateAvailableChatRooms{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
    
}


@end
