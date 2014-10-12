//
//  ChatViewController.m
//  DYO
//
//  Created by Sean Crowe on 9/20/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "ChatViewController.h"

//From demo//
static NSString * const kJSQDemoAvatarNameCook = @"Tim Cook";
static NSString * const kJSQDemoAvatarNameJobs = @"Jobs";
static NSString * const kJSQDemoAvatarNameWoz = @"Steve Wozniak";
//From demo//

@implementation ChatViewController

#pragma mark - Lazy Instantiation
-(NSMutableArray *)chats {
    if (!_chats){
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

#pragma mark - Chat Setup
- (void)setupTestModel
{
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithText:@"Welcome to JSQMessages: A messaging UI framework for iOS." sender:self.sender date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy." sender:kJSQDemoAvatarNameWoz date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com." sender:self.sender date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better." sender:kJSQDemoAvatarNameJobs date:[NSDate date]],
                     [[JSQMessage alloc] initWithText:@"It is unit-tested, free, and open-source." sender:kJSQDemoAvatarNameCook date:[NSDate date]],
                     [[JSQMessage alloc] initWithText:@"Oh, and there's sweet documentation." sender:self.sender date:[NSDate date]],
                     nil];
    
    CGFloat outgoingDiameter = self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    
    UIImage *jsqImage = [JSQMessagesAvatarFactory avatarWithUserInitials:@"JSQ"
                                                         backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                               textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                    font:[UIFont systemFontOfSize:14.0f]
                                                                diameter:outgoingDiameter];
    
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    
    UIImage *cookImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
                                                          diameter:incomingDiameter];
    
    UIImage *jobsImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]
                                                          diameter:incomingDiameter];
    
    UIImage *wozImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_woz"]
                                                         diameter:incomingDiameter];
    self.avatars = @{ self.sender : jsqImage,
                      kJSQDemoAvatarNameCook : cookImage,
                      kJSQDemoAvatarNameJobs : jobsImage,
                      kJSQDemoAvatarNameWoz : wozImage };
    
    /*
    self.currentUser = [PFUser currentUser];        //set current user property to the pfcurrent user
    PFUser *testUser1 = self.chatRoom[@"user1"];    //set a test user to the field 'user1' in the PFObject property chatRoom
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId]){    //if current user matches the user in the mutable array, then 'user2' must be the OTHER person we're talking to
        self.withUser = self.chatRoom[@"user2"];
    }
    else {
        self.withUser = self.chatRoom[@"user1"];    //otherwise, 'user1' is the OTHER user and 'user2' is the current user
    }
    
    self.title = self.withUser[@"firstName"];
    self.initialLoadComplete = NO; */
    
}


#pragma mark - View lifecycle

-(void)viewDidLoad{
    //Good
    [super viewDidLoad];
    [self setupTestModel];
    self.sender = @"Jesse Squires";    
    //remove camera button
    self.inputToolbar.contentView.leftBarButtonItem = nil;
   
    
    /**
     *  Create bubble images.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     */
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"typing"]
//                                                                              style:UIBarButtonItemStylePlain
//                                                                             target:self
//                                                                             action:@selector(receiveMessagePressed:)];
    //if nil on avatars use these methods
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDid
     Appear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}


- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    //good
    JSQMessage *message = [[JSQMessage alloc] initWithText:text sender:sender date:date];
    [self.chats addObject:message];
    
    PFObject *chat = [PFObject objectWithClassName:@"Chat"]; //create a new PFObject called *chat. Basically a table to record messages
    [chat setObject:self.chatRoom forKey:@"chatroom"];      //There is a field in the Chat table called ChatRoom...this links to the corresponding chatroom entry
    [chat setObject:[PFUser currentUser] forKey:@"fromUser"]; //the fromUser is current user
    [chat setObject:self.withUser forKey:@"toUser"];        //the toUser is 'withUser' that we set in view did load setup
    [chat setObject:text forKey:@"text"];                   //the message is put in a 'text' column

    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //NSLog(@"save message to Parse complete");
        [self.chats addObject:chat];
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        //[self.tableView reloadData];
        [self finishSendingMessage];
        [self scrollToBottomAnimated:YES];
    }];
}


#pragma mark - IDK

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chats objectAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Good
    //bubbbles
    PFObject *chat = self.chats[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testFromUser = chat[@"fromUser"];
    
    if ([testFromUser.objectId isEqual:currentUser.objectId]){
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    else{
        return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                                 highlightedImage:self.incomingBubbleImageView.highlightedImage];
    }
    
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    UIImage *avatarImage = [self.avatars objectForKey:message.sender];
    return [[UIImageView alloc] initWithImage:avatarImage];

}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.chats objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chats objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.sender isEqualToString:self.sender]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chats objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:message.sender]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.sender];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Good
    return [self.chats count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.chats objectAtIndex:indexPath.item];
    
    if ([msg.sender isEqualToString:self.sender]) {
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chats objectAtIndex:indexPath.item];
    if ([[currentMessage sender] isEqualToString:self.sender]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chats objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:[currentMessage sender]]) {
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

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


@end
