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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize the property userSearchResults
   self.userMutableArray = [NSMutableArray array];
    
    //Get all of the data into an array
    //for now, lets just get all users
    //This is where we will change the search query in the future
    
    //PFQuery *query = [PFUser query];
   // NSArray *resultsArray = [query findObjects];     //now all of the objects from the query are in *resutlsArray

    NSLog(@"array passed to me contains: %@", self.userSearchResults);
    for (NSArray *usersArray in self.userSearchResults){ //in the for loop to go through all the results
        
        User *user = [User userWithEmail:[usersArray valueForKey:@"email"]];         //declare new USER object
        user.companyName = [usersArray valueForKey:@"company"];                     //set the properties of the user class
        user.educationLabel = [usersArray valueForKey:@"education"];
        user.jobTitle = [usersArray valueForKey:@"jobTitle"];
        user.firstName = [usersArray valueForKey:@"firstName"];
        user.lastName = [usersArray valueForKey:@"lastName"];
        user.userID = [usersArray valueForKey:@"objectId"];
        user.recentLocation = [usersArray valueForKey:@"lastLocation"];
        user.areaOfStudy = [usersArray valueForKey:@"areaOfStudy"];
        user.industry = [usersArray valueForKey:@"industry"];
        
        PFFile *userImageFile = [usersArray valueForKey:@"photo"]; //declare a Parse file datatype obect and store the file
        if(userImageFile){
            //go to parse and get the image
            NSData *imageData = [userImageFile getData];
            UIImage *image = [UIImage imageWithData:imageData];
            user.profileImage = image;
        }
        else{
            user.profileImage = [UIImage imageNamed:@"profilePlaceholder.png"];
        }
        
        //add to local mutable array
        [self.userMutableArray addObject:user];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:NO];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setHidden:NO];
    [navBar setTitleTextAttributes: @{
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Montserrat-Regular" size:17.0f],
                                      }];
    
    navBar.tintColor =[UIColor whiteColor]; //back button color
    navBar.backgroundColor = [UIColor colorWithRed:0.965 green:0.4 blue:0.024 alpha:1];
   

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.userMutableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    User *user = [self.userMutableArray objectAtIndex:indexPath.row];
    

    // I go get the cell and tell him the set each field text property
    //I set the text to properties in the user class
    //the information was set in the view did load for the user properties
    //NSLog(@"First Name: %@", self.userMutableArray);
    [cell.firstNameLabel setText:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
    cell.jobTitle.text =        user.jobTitle;
    cell.companyLabel.text =    user.companyName;
    cell.educationLabel.text =  user.educationLabel;
    cell.profileImage.image = user.profileImage;
    cell.industryLabel.text = user.industry;
    cell.studyLabel.text = user.areaOfStudy;
    cell.lastLocationLabel.text =[NSString stringWithFormat:@"%.3f", [self.currentLocation distanceInMilesTo:user.recentLocation]];
    
    //NSLog(@"distance in miles is: %f", [self.currentLocation distanceInMilesTo:user.recentLocation]);
    
    
    //set tag to the indexPath
    [cell.likeBtn setTag:indexPath.row];
    
    //listen for this button being pressed, and then run method likeButtonClick
    [cell.likeBtn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //get the geopoint for the search result user
    
    return cell;
}

-(void)likeButtonClick:(id)sender{
    
    //app is listening for a user to click one of the send message buttons
    //when user clics one of them, this method executes
    
    UIButton *senderButton = (UIButton *)sender;
    //NSLog(@"Current row = %ld", (long)senderButton.tag); //senderButton.tag contains the row number selected
    
    User *selectedUser = [self.userMutableArray objectAtIndex:senderButton.tag]; //instantiate new object of type USER, get index path
    self.userSelected = [PFQuery getUserObjectWithId:selectedUser.userID]; //set the userSelected property to the correct user
    [self createChatRoom:self.userSelected]; //go create a chatroom between the cuurent user and selected user
    [self performSegueWithIdentifier:@"showSearchMessage" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showSearchMessage"]) {
        ChatView *matchVC = segue.destinationViewController;
        matchVC.chatRoomObject = [self.chatRoom objectAtIndex:0]; //FAILING BECAUSE THE CHATROOM OBJECT IS NULL
        //matchVC.selectedUserImage = self.userImage;
        matchVC.delegate = self;
        matchVC.isFirstMessage = true;
    }
}

-(void)createChatRoom:(PFUser *)userSelected{
    //I am called when a user selects the 'send message' button in the search results
    //list view.
    
    //NSLog(@"create called");
    //Give me back all of the available chatrooms where user 1 is the current user
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:userSelected];
    
    //Give me back all of the available chatrooms where user 2 is the current user
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:userSelected];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    ///////////////////////////////////////
    //testing purposes for threading shit//
    NSArray *objects = [combinedQuery findObjects];
    
    //NSLog(@"here is what the query found: %@", objects);
    
    if([objects count]==0){
        //NSLog(@"no chatroom found, one will be made shortly");
        PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
        [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
        [chatroom setObject:userSelected forKey:@"user2"];
        [chatroom save];
    }
    
    
    self.chatRoom = [[combinedQuery findObjects] mutableCopy];
    //NSLog(@"THIS IS YOUR CHATROOM WE JUST CREATED: %@", self.chatRoom[0][@"user1"]);
    
    

//THE CODE BELOW IS THE CODE ABOVE EXCEPT USING BACKGROUND PROCESSES//
    
//    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if ([objects count] == 0) {
//            NSLog(@"no chatroom found, one will be made shortly");
//            //if there isn't a chatroom already in existence between these users
//            //then we will make one!!!
//            //yay
//            
//            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
//            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
//            [chatroom setObject:userSelected forKey:@"user2"];
//            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                //[self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
//                NSLog(@"Success! You have just created a new chatroom");
//                //Tell user the message is sent and take them back to the search results
//            }];
//            
//        }
//    
//        [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            //we checked if chatroom exists. It didnt'
//            //then we made one on parse
//            //now lets go get that chatroom dude
//            if (!error) {
//                [self.chatRoom removeAllObjects];
//                self.chatRoom = [objects mutableCopy];
//                NSLog(@"your chatroom object is: %@", self.chatRoom);
//            }
//        }];
//    
//    }];
    
   
    
    //I made you a nice object called chatroom object that you can use in the prepare for seuque
    //statement. This is passed on to the chatveiw

}

- (IBAction)messagePressed:(id)sender {
}
@end
