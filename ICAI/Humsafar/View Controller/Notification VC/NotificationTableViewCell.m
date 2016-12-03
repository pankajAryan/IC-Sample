//
//  NotificationTableViewCell.m
//  ICAI
//
//  Created by Pardeep on 02/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NotificationTableViewCell
@synthesize viewContainer;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    viewContainer.layer.masksToBounds = NO;
    viewContainer.layer.shadowOffset = CGSizeMake(0, 0);
    viewContainer.layer.shadowRadius = 1;
    viewContainer.layer.shadowOpacity = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
