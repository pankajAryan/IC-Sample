//
//  TestListTableViewCell.h
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTestTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuesCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UIButton *buttonTestAction;

@end
