//
//  TableViewCell.h
//  DYO
//
//  Created by Sean Crowe on 9/11/14.
//  Copyright (c) 2014 Sean Crowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;




@end
