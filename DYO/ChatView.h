//
//  ChatView.h
//  
//
//  Created by Sean Crowe on 9/22/14.
//
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"

@class ChatView;
@protocol ChatViewDelegate <NSObject>

- (void)didDismissChatView:(ChatView *)vc;

@end

@interface ChatView : JSQMessagesViewController

    @property (weak) id<ChatViewDelegate> delegateModal;
    @property (weak) id<ChatViewDelegate> delegate;

    //
    @property (strong, nonatomic) NSTimer *chatsTimer;
    @property (nonatomic) BOOL isLoading;
    @property (strong, nonatomic) NSString *chatRoom;
    @property (strong, nonatomic) NSMutableArray *messages;
    @property (strong, nonatomic) NSMutableArray *users;
    @property (copy, nonatomic) NSMutableDictionary *avatars;
    @property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
    @property (strong, nonatomic) UIImageView *incomingBubbleImageView;
    @property (strong, nonatomic) PFObject *chatRoomObject;
    @property (strong, nonatomic) UIImage *selectedUserImage;
    @property (nonatomic) int initialLoadNum;
    @property (nonatomic) int numberMessageToLoad;
    @property (nonatomic) int incrementLoadNum;
    @property (strong, nonatomic) PFUser *withUser;
    @property (strong, nonatomic) PFUser *currentUser;




@end
