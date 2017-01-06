//
//  AnswerTableViewCell.h
//  ICAI
//
//  Created by Pankaj Yadav on 17/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewOptionContainer;
@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAnswer;


@end
