//
//  TestListTableViewCell.m
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "TestListTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TestListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _viewContainer.layer.masksToBounds = NO;
    _viewContainer.layer.shadowOffset = CGSizeMake(0, 0);
    _viewContainer.layer.shadowRadius = 1;
    _viewContainer.layer.shadowOpacity = 1.0;
    
    _viewContainer.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
}


@end
