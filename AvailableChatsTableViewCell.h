//
//  AvailableChatsTableViewCell.h
//  DYO
//
//  Created by Sean Crowe on 10/1/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableChatsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageExcerpt;

@end
