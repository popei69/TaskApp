//
//  CustomerCell.h
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *gravatarView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
