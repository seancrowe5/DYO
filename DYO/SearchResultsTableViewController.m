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
    self.userSearchResults = [NSMutableArray array];
    
    //Get all of the data into an array
    //for now, lets just get all users
    //This is where we will change the search query in the future
    
    PFQuery *query = [PFUser query];
    NSArray *resultsArray = [query findObjects];     //now all of the objects from the query are in *resutlsArray

    
    for (NSArray *usersArray in resultsArray){ //in the for loop to go through all the results
        
        User *user = [User userWithEmail:[usersArray valueForKey:@"email"]];         //declare new USER object
        user.companyName = [usersArray valueForKey:@"company"];                     //set the properties of the user class
        user.educationLabel = [usersArray valueForKey:@"education"];
        user.jobTitle = [usersArray valueForKey:@"jobTitle"];
        user.firstName = [usersArray valueForKey:@"firstName"];
        user.userID = [usersArray valueForKey:@"objectId"];
        
        PFFile *userImageFile = [usersArray valueForKey:@"photo"]; //declare a Parse file datatype obect and store the file
        NSData *imageData = [userImageFile getData];            //put image in NSData object
        UIImage *image = [UIImage imageWithData:imageData];     //take data and put in UIimage so we can use it
        user.profileImage = image;                              //sets profile pic in user class
        
        
        
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if(!error){
//                UIImage *image = [UIImage imageWithData:data];
//                user.profileImage = image;
//            }
//            
//        }];
        
       // NSData *imageData = [userImageFile getData];               //convert the image to NSData object type so that we can
                 //put it in a UIImage object to allow us to use it
                                           //set the user profile image property with the UIImage
        
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
    
    //set tag to the indexPath
    [cell.likeBtn setTag:indexPath.row];
    
    //listen for this button being pressed, and then run method likeButtonClick
    [cell.likeBtn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

-(void)likeButtonClick:(id)sender{
    
    //DON'T LET THE USER CLICK SEND MESSAGE TWICE!!!
    //This code should be when the user sends the first message
    
    UIButton *senderButton = (UIButton *)sender;
    NSLog(@"Current row = %ld", (long)senderButton.tag);
    
    User *selectedUser = [self.userSearchResults objectAtIndex:senderButton.tag]; //instantiate new object of type USER, get index path
    PFUser *userSelected = [PFQuery getUserObjectWithId:selectedUser.userID]; //
    
    [self createChatRoom:userSelected];
    
//    //MOVE THIS CODE TO THE ACTUAL MESSAGE THAT IS SENT
//    PFObject *likeActivity = [PFObject objectWithClassName:@"Chat"]; //set likeActivity object as a new Parse class Actiivity
//    [likeActivity setObject:@"like" forKey:@"isLiked"];                    // set likeActivity object field 'type' to the value of 'like'
//    [likeActivity setObject:[PFUser currentUser] forKey:@"user1"];   //set likeActivity object field 'fromUser' to the value of currentUser
//    [likeActivity setObject:userSelected forKey:@"user2"];
//    
//    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if(error){
//            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Try Liking Again!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }];

}


-(void)createChatRoom:(PFUser *)userSelected{
    NSLog(@"create called");
    //Give me back all of the available chatrooms where user 1 is the current user
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:userSelected];
    
    //Give me back all of the available chatrooms where user 2 is the current user
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:userSelected];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:userSelected forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //[self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
                NSLog(@"Success! You have just created a new chatroom");
                //Tell user the message is sent and take them back to the search results
            }];
        }
    }];
}

@end
