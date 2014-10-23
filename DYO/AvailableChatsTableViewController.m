
//
//  AvailableChatsTableViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/15/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "AvailableChatsTableViewController.h"
#import "AvailableChatsTableViewCell.h"


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

    //Call the helper method defined below to get the updated list of chatrooms
    [self updateAvailableChatRooms];
    
//    self.listOfAvatars = [[NSMutableArray alloc] init];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                      }];
    self.navigationItem.title = @"MESSAGES";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;



}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f],
                                                                       }];
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
    AvailableChatsTableViewCell *cell = (AvailableChatsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    PFObject *chatroom = [self.availableChatRooms objectAtIndex:indexPath.row]; //accessing chatroom
    PFUser *selectedUser; //selected user
    PFUser *currentUser = [PFUser currentUser]; //current user
    PFUser *testUser1 = chatroom[@"user1"]; //I am setting a temporary user object to the user1 from the chatroom element [row] from the array available chatroom //sean
    if ([testUser1.objectId isEqual:currentUser.objectId]) { //sean == sean
        selectedUser = [chatroom objectForKey:@"user2"]; //then roger
    }
    else {
        selectedUser = [chatroom objectForKey:@"user1"];
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query whereKey:@"chatroom" equalTo:chatroom]; //looks for all messages with the same chatroom object as the current cell
    [query orderByDescending:@"createdAt"];
    PFObject *lastMessageObject = [PFObject objectWithClassName:@"Chat"];
    lastMessageObject = [query getFirstObject];
    
    cell.messageExcerpt.text = lastMessageObject[@"text"];
    cell.messageExcerpt.textColor = [UIColor lightGrayColor];

    cell.userName.text = selectedUser[@"firstName"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    [formatter setDateFormat:@"h:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    
    
    NSDate *time = lastMessageObject.createdAt;
    NSString *messageDate = [formatter stringFromDate:time];
    
    [cell.timeLabel setText:messageDate];
    //Images in Cells//
    
    //cell.imageview.image = placeholderImage;
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    PFFile *userImageFile = [selectedUser valueForKey:@"photo"]; //declare a Parse file datatype obect and store the file
    
    //GET DATA IN BACKGROUND ???? //
    ///////////////////////////////
//    NSData *imageData = [userImageFile getData]; //put image in NSData object
//    self.userImage = [UIImage imageWithData:imageData]; //asign property userImage the image from data
//    [self.listOfAvatars addObject:self.userImage];
//    cell.imageView.image =[self.listOfAvatars objectAtIndex:indexPath.row]; //display the userImage property
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
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
        //matchVC.selectedUserImage = self.userImage;
        matchVC.delegate = self;
        matchVC.isFirstMessage = false;
        

    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"availableChatsToMessages" sender:indexPath];
    
    
}

#pragma mark - Helper

-(void)updateAvailableChatRooms{
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"]; //let's query the chatroom class
    [query whereKey:@"user1" equalTo:[PFUser currentUser]]; //give me all results when the user1 column is equal to the current user
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"]; //lets also check the same class but a different colum
    [query whereKey:@"user2" equalTo:[PFUser currentUser]]; //give me all results when the user2 column is equal to the current user, just incase the current user didn't start convo
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query, queryInverse]];
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    [queryCombined orderByDescending:@"createdAt"];
    
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.availableChatRooms removeAllObjects];
            self.availableChatRooms = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
    
}


@end
