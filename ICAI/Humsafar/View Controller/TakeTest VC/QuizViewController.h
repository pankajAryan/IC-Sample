//
//  QuizViewController.h
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblQuizTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UITableView *tableViewQA;

- (IBAction)nextButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;
- (IBAction)resetButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;


@end