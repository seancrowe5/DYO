//
//  JSQDemoViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/21/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import "JSQMessages.h"

@class JSQDemoViewController;


@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(JSQDemoViewController *)vc;

@end



@interface JSQDemoViewController : JSQMessagesViewController

@property (weak) id<JSQDemoViewControllerDelegate> delegateModal;
@property (weak) id<JSQDemoViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *chat;

@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

@property (strong, nonatomic) PFObject *chatRoom;
@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;



- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;

@end
