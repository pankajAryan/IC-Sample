//
//  ReviewResultViewController.h
//  ICAI
//
//  Created by Pankaj Yadav on 17/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewResultViewController : UIViewController

@property (strong, nonatomic) NSDictionary *quizDict;

@property (weak, nonatomic) IBOutlet UILabel *lblQuizTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizNumber;

@property (weak, nonatomic) IBOutlet UITableView *tableViewQA;

- (IBAction)nextButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;


@end
