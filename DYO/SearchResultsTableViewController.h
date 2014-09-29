//
//  SearchResultsTableViewController.h
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "JSQDemoViewController.h"
#import "ChatView.h"

@interface SearchResultsTableViewController : UITableViewController <ChatViewDelegate>
@property (nonatomic, strong) NSMutableArray *userSearchResults;
@property (nonatomic, strong) PFUser *userSelected;
@property (nonatomic, strong) NSMutableArray *chatRoom;



@end
