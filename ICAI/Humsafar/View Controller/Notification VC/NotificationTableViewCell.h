//
//  NotificationTableViewCell.h
//  ICAI
//
//  Created by Pardeep on 02/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelQuestionTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelQuestionDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end
