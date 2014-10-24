//
//  ChatView.m
//  
//
//  Created by Sean Crowe on 9/22/14.
//
//

//#import "ProgressHUD.h"
//#import "AppConstant.h"
//#import "ViewProfile.h"
#import "ChatView.h"


@implementation ChatView

@synthesize chatRoom;
@synthesize chatRoomObject;

- (id)initWith:(NSString *)chatRoom_
{
    self = [super init];
    chatRoom = chatRoom_;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //make sure nav shows
    [self.navigationController.navigationBar setHidden:NO];
   
    //i added for avatar stuff change something here for the load maybe?
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.users = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    //self.avatars = [[NSMutableDictionary alloc] init];
    
    self.sender = [PFUser currentUser].objectId;
    
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor colorWithRed:241.0/255.0 green:106.0/255.0 blue:108.0/255.0 alpha:1]];
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor colorWithRed:90.0/255.0 green:196.0/255.0 blue:190.0/255.0 alpha:1]];
    
    // = CGPointMake(self.outgoingBubbleImageView.size.width/2.0f, self.outgoingBubbleImageView.size.height/2.0f);
    
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont fontWithName:@"Avenir" size:14.0f];
   self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    
    self.initialLoadNum = 5;
    self.numberMessageToLoad =self.initialLoadNum;
    self.incrementLoadNum = 4;
    
    
    
    self.isLoading = NO;
    
    if(self.isFirstMessage == false){
        //if first message is false, then run
        [self loadMessages:false];
    }
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
    
    self.currentUser = [PFUser currentUser];        //set current user property to the pfcurrent user
    PFUser *testUser1 = chatRoomObject[@"user1"];    //set a test user to the field 'user1' in the PFObject property chatRoom

    if ([testUser1.objectId isEqual:self.currentUser.objectId]){    //if current user matches the user in the mutable array, then 'user2' must be the OTHER person we're talking to
        self.withUser = self.chatRoomObject[@"user2"];
    }
    else {
        self.withUser = self.chatRoomObject[@"user1"];    //otherwise, 'user1' is the OTHER user and 'user2' is the current user
    }

    if(self.isFirstMessage == false){
        //you came from the message tab
        NSString *userTitle = [[[NSString alloc] initWithString:self.withUser[@"firstName"]] uppercaseString];
        self.title = userTitle;
    }
    else{
        self.title = @"Message";
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    //make sure nav shows
    [self.navigationController.navigationBar setHidden:NO];
    
   
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.chatsTimer invalidate];
}

-(void)refreshMessages
{
    [self loadMessages:false];
}

- (void)loadMessages:(BOOL)bLoadMore
{
    if (self.isLoading == NO)
    {
        self.isLoading = YES;
        JSQMessage *message_last = [self.messages lastObject];
    
        PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
        //FAILING HERE BECAUSE THE CHATROOMOBJECT IS NULL
        [query whereKey:@"chatroom" equalTo:self.chatRoomObject];
        NSLog(@"Message Last is: %@",message_last);
        //bLoadMore = true;
        NSLog(@"bload: %d",bLoadMore);
        NSLog(@"Date: %@",message_last.date);

        if (message_last != nil && bLoadMore==false) [query whereKey:@"createdAt" greaterThan:message_last.date];
        [query includeKey:@"toUser"]; //changes this?
        [query orderByDescending:@"createdAt"];
        [query setLimit:self.numberMessageToLoad];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             NSLog(@"YOU ARE in the load messages loop, here ar the objects %@",objects);
             if (error == nil)
             {
                 if(bLoadMore==true)
                 {
                     [self.messages removeAllObjects];
                 }
                 
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     //this adds a user into the USERS array for each message
                     //since the fromUser and toUser alternates each message, every user is added
                     
                     PFUser *user = object[@"fromUser"]; //This changes the side of the screen the messages are on @"toUser"
                     [self.users addObject:user];
                     
                     JSQMessage *message = [[JSQMessage alloc] initWithText:object[@"text"] sender:user.objectId date:object.createdAt];
                     [self.messages addObject:message];
                     
                    }
                 if ([objects count] != 0)
                 {
                     [self finishReceivingMessage];
                     if([self.messages count]>=self.numberMessageToLoad)
                     {
                         
                         self.showLoadEarlierMessagesHeader = YES;
                     }
                     else
                     {
                         self.showLoadEarlierMessagesHeader = NO;
                     }
                 }
             }
             //else [ProgressHUD showError:@"Network error."];
             self.isLoading = NO;
         }];
    }
}

//customize the load messages label
- (UICollectionReusableView *)collectionView:(JSQMessagesCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (self.showLoadEarlierMessagesHeader && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JSQMessagesLoadEarlierHeaderView *header = [collectionView dequeueLoadEarlierMessagesViewHeaderForIndexPath:indexPath];
        
        // Customize header
        [header.loadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [header.loadButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:12.0f]];
        
        
        return header;
    }
    
    return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind
                     atIndexPath:indexPath];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
{

    PFObject *object = [PFObject objectWithClassName:@"Chat"];
    object[@"chatroom"] = self.chatRoomObject;
    object[@"fromUser"] = [PFUser currentUser]; //CHECK
    object[@"toUser"] = self.withUser;        //the toUser is 'withUser' that we set in view did load setup
    object[@"text"] = text;
    
    NSInteger num = [[self.chatRoomObject objectForKey:@"numberOfMesages"] integerValue] + 1;
    self.chatRoomObject[@"numberOfMessages"] = [NSNumber numberWithInteger:num];
    
    [PFObject saveAllInBackground:@[object,self.chatRoomObject] block:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
             [self loadMessages:false];
         }
         else
         {
             //[ProgressHUD showError:@"Network error"];
         }
     }];
    
    [self finishSendingMessage];
    
    if(self.isFirstMessage == true){ //aka you came from search
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                            message:@" Your messages was sent successfully."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
      
        
    }
    // Associate the device with a user
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = self.withUser;
    [installation saveInBackground];
    
    
    // Create our Installation query
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" equalTo:self.currentUser];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:object[@"text"]];
    [push sendPushInBackground];
    
  //Push notification test
    // When users indicate they are Giants fans, we subscribe them to that channel.
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    [currentInstallation addUniqueObject:self.withUser.objectId forKey:@"channels"];
//    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        PFPush *push = [[PFPush alloc] init];
//        [push setChannel:self.withUser.objectId];
//        [push setMessage:object[@"text"]];
//        [push sendPushInBackground];
//    }];
//    
   
    
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"didPressAccessoryButton");
}

- (void)messagesCollectionViewCellDidTapCell:(JSQMessagesCollectionViewCell *)cell atPosition:(CGPoint)position
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    return;
    //test ing
}

- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesCollectionViewCell *)cell
{
    /*USE THIS TO DISPLAY INFORMATION ON THE USER WHEN THEY CLICK ON THE AVATAR PICUTRE
     *
     *
     */
}


- (void)messagesCollectionViewCellDidTapMessageBubble:(JSQMessagesCollectionViewCell *)cell
{
    /**
     *  Tells the delegate that the message bubble of the cell has been tapped.
     *
     *  @param cell The cell that received the tap touch event.
     */
    
    //NSInteger userPos = cell.tag;
    //ViewProfile *profileFile = [[ViewProfile alloc] init];
    //profileFile.passedUser = [users objectAtIndex:userPos];
    //[self.navigationController pushViewController:profileFile animated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"YOU ARE IN COLLECTION VIEW MESSAGE DATA AND HERE ARE YOUR MESSAGES: %@", [self.messages objectAtIndex:indexPath.item]);
    return [self.messages objectAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([[message sender] isEqualToString:self.sender])
    {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    else return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image highlightedImage:self.incomingBubbleImageView.highlightedImage];
}


- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    PFUser *user = [self.users objectAtIndex:indexPath.item]; //New user object...set to the user of the current text message in loop
//    UIImageView *imageView = [[UIImageView alloc] init]; //sets the placeholder image
//   
//    NSString *messageUserID = user.objectId;
//    NSString *currentUserID = self.currentUser.objectId;
//    
//    if([messageUserID isEqualToString:currentUserID]){
//        //get current user image
//        PFFile *userImageFile = self.currentUser[@"photo"];
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error) {
//                UIImage *image = [UIImage imageWithData:imageData];
//                [imageView setImage:image];
//            }
//        }];
//
//    }
//    else{
//        //set the imageview to the one passed from previous view self.selectedImage
//        [imageView setImage:self.selectedUserImage];
//    }
//    
////    imageView.layer.cornerRadius = imageView.frame.size.width/2;
////    imageView.layer.masksToBounds = YES;
//    
    return nil;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //IF WE WANT TO SHOW THE OTHER USER NAME, USE SOMETHING CLOSE TO THE CODE BELOW. I'M HAVING TROUBLE GETTING THE USER[@"FIRSTNAME"] TO SHOW UP THOUGH SO NOT DOING IT FOR NOW.
    ///////////////////////////////////////////////////
    
    
//    PFUser *user = [self.users objectAtIndex:indexPath.item]; //New user object...set to the user of the current text message in loop
    
    //-> THIS PART DOESNT WORK -> NSObject *withUserName = user[@"firstName"];//
//    
//    NSString *messageUserID = user.objectId;
//    NSString *currentUserID = self.currentUser.objectId;
//
//
//    if ([messageUserID isEqualToString:currentUserID])
//    {
//        //if the message sender is the current user, don't show the user his own name
//        return nil;
//    }
//    else{
//        //othershise show the name
//        return [[NSAttributedString alloc] initWithString:@"other name"];
//    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.sender isEqualToString:self.sender])
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:cell.textView.textColor,
                                         NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)};
    
    cell.tag = [indexPath row];
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([[message sender] isEqualToString:self.sender])
    {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:[message sender]])
        {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    self.numberMessageToLoad += self.incrementLoadNum;
    [self loadMessages:true];

}

@end
