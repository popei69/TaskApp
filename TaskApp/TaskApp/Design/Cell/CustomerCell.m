//
//  CustomerCell.m
//  TaskApp
//
//  Created by Benoit PASQUIER on 24/03/2015.
//  Copyright (c) 2015 Benoit Pasquier. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell

@synthesize nameLabel, timeLabel, gravatarView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
