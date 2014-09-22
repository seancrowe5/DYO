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

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)chatRoom_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    chatRoom = chatRoom_;
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    self.title = @"Chat Name";
    //i added for avatar stuff
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.users = [[NSMutableArray alloc] init];
    self.messages = [[NSMutableArray alloc] init];
    //avatars = [[NSMutableDictionary alloc] init];
    
    self.sender = [PFUser currentUser].objectId;
    
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.initialLoadNum = 5;
    self.numberMessageToLoad =self.initialLoadNum;
    self.incrementLoadNum = 4;
    
    
    self.isLoading = NO;
    [self loadMessages:false];
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
    
    self.currentUser = [PFUser currentUser];        //set current user property to the pfcurrent user
    PFUser *testUser1 = chatRoomObject[@"user1"];    //set a test user to the field 'user1' in the PFObject property chatRoom

    if ([testUser1.objectId isEqual:self.currentUser.objectId]){    //if current user matches the user in the mutable array, then 'user2' must be the OTHER person we're talking to
        self.withUser = self.chatRoomObject[@"user2"];
    }
    else {
        self.withUser = self.chatRoomObject[@"user1"];    //otherwise, 'user1' is the OTHER user and 'user2' is the current user
    }

    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillDisappear:animated];
    [self.chatsTimer invalidate];
}

-(void)refreshMessages
{
    [self loadMessages:false];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages:(BOOL)bLoadMore
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (self.isLoading == NO)
    {
        self.isLoading = YES;
        JSQMessage *message_last = [self.messages lastObject];
    
        PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
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

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
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
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"didPressAccessoryButton");
}

- (void)messagesCollectionViewCellDidTapCell:(JSQMessagesCollectionViewCell *)cell atPosition:(CGPoint)position
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    return;
}

- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesCollectionViewCell *)cell
{
    //NSInteger userPos = cell.tag;
    //ViewProfile *profileFile = [[ViewProfile alloc] init];
    //profileFile.passedUser = [users objectAtIndex:userPos];
    //[self.navigationController pushViewController:profileFile animated:YES];
}

/**
 *  Tells the delegate that the message bubble of the cell has been tapped.
 *
 *  @param cell The cell that received the tap touch event.
 */
- (void)messagesCollectionViewCellDidTapMessageBubble:(JSQMessagesCollectionViewCell *)cell
{
    //NSInteger userPos = cell.tag;
    //ViewProfile *profileFile = [[ViewProfile alloc] init];
    //profileFile.passedUser = [users objectAtIndex:userPos];
    //[self.navigationController pushViewController:profileFile animated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSLog(@"YOU ARE IN COLLECTION VIEW MESSAGE DATA AND HERE ARE YOUR MESSAGES: %@", [self.messages objectAtIndex:indexPath.item]);
    return [self.messages objectAtIndex:indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([[message sender] isEqualToString:self.sender])
    {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    else return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image highlightedImage:self.incomingBubbleImageView.highlightedImage];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//    PFUser *user = [self.users objectAtIndex:indexPath.item];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank_avatar"]]; //111-user
//    
//
//    if (avatars[user.objectId] == nil)
//    {
//        PFFile *filePicture = user[PF_USER_THUMBNAIL]; //PF_USER_THUMBNAIL
//        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
//         {
//             if (error == nil)
//             {
//                 avatars[user.objectId] = [UIImage imageWithData:imageData];
//                 [imageView setImage:avatars[user.objectId]];
//             }
//         }];
//    }
//    else [imageView setImage:avatars[user.objectId]];
//    
//    imageView.layer.cornerRadius = imageView.frame.size.width/2;
//    imageView.layer.masksToBounds = YES;
    
    return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.sender isEqualToString:self.sender])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:message.sender])
        {
            return nil;
        }
    }
    
//    PFUser *user = [self.users objectAtIndex:indexPath.item];
//    
//    NSString *pfDisplayName = [user objectForKey:@"firstName"];
//    
//    if([pfDisplayName length]>1)
//    {
//        return [[NSAttributedString alloc] initWithString:user[@"firstName"]];
//    }
//    else
//    {
//        return [[NSAttributedString alloc] initWithString:user[@"firstName"]];
//    }
    return nil;
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [self.messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.sender isEqualToString:self.sender])
    {
        cell.textView.textColor = [UIColor blackColor];
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

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
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

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self.numberMessageToLoad += self.incrementLoadNum;
    [self loadMessages:true];
}

@end
