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

@class SearchResultsTableViewController;
@protocol SearchResultsTableViewControllerDelegate <NSObject>
@end

@interface SearchResultsTableViewController : UITableViewController <ChatViewDelegate>
@property (weak) id<SearchResultsTableViewControllerDelegate> delegate;


@property (nonatomic, strong) NSArray *userSearchResults;
@property (nonatomic, strong) NSMutableArray *userMutableArray;
@property (nonatomic, strong) PFGeoPoint *currentLocation;
@property (nonatomic, strong) PFUser *userSelected;
@property (nonatomic, strong) NSMutableArray *chatRoom;



@end
