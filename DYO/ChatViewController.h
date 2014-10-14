//
//  ChatViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/20/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "JSQMessages.h"


@class ChatViewController;


@protocol ChatViewControllerDelegate <NSObject>

- (void)didDismissChatViewController:(ChatViewController *)vc;

@end


@interface ChatViewController : JSQMessagesViewController

@property (weak, nonatomic) id<ChatViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

//- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

//- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;

@property (strong, nonatomic) PFObject *chatRoom;
@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;
@property (strong, nonatomic) NSMutableArray *chats;

@end
