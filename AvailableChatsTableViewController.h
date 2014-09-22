//
//  AvailableChatsTableViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/15/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQDemoViewController.h"
#import "ChatView.h"

@interface AvailableChatsTableViewController : UITableViewController <ChatViewDelegate>
@property (strong,nonatomic) NSMutableArray *availableChatRooms;

@end
