//
//  QuizViewController.h
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizViewController : UIViewController

@property (strong, nonatomic) NSDictionary *quizDict;
@property (strong, nonatomic) NSDictionary *questionsDict;

@property (strong, nonatomic) NSString *timeleftInms;

@property (weak, nonatomic) IBOutlet UILabel *lblQuizTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblNext;

@property (weak, nonatomic) IBOutlet UITableView *tableViewQA;
@property (weak, nonatomic) IBOutlet UIButton *showListBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;


- (IBAction)nextButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;
- (IBAction)resetButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;

-(void)selctedQuestionIndex:(NSInteger)index;
-(void)hideQuestionList;

@end
