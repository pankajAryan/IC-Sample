//
//  QuizViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "QuizViewController.h"
#import "AnswerTableViewCell.h"
#import "DataModels.h"

@interface QuizViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    NSString *studentID;
    NSString *quizID;
    NSString *questionIDs;
    
    NSInteger currentQuizIndex;
    QuizBaseClass *quizBaseObject;
}

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentQuizIndex = 1;
    [_tableViewQA setRowHeight:UITableViewAutomaticDimension];
    _tableViewQA.estimatedRowHeight = 44;
    
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    _lblTime.text = [NSString stringWithFormat:@"%@",[_quizDict objectForKey:@"timeMinutes"]]; //TODO: Start a countdown timer and change _lblTime's text accordingly.
    
    studentID = [_quizDict objectForKey:@"studentId"];
    quizID = [_quizDict objectForKey:@"quizId"];
    questionIDs = [_quizDict objectForKey:@"questionIds"];
    
    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_ATTEMPT]
     withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionIds":questionIDs, CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             quizBaseObject = [QuizBaseClass modelObjectWithDictionary:response];
             [_tableViewQA reloadData];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (quizBaseObject.responseArray.count != 0) ? 5 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        
        UILabel *question = [cell viewWithTag:21];
        question.text = @"My name is anthony gonsalvis, which movie is this?";
    }
    else {
        AnswerTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        
        optionCell.lblAnswer.text = @"Amar akbar anthony";
        optionCell.radioButton.tag = indexPath.row;
        
        return optionCell;
    }
    
    return cell;
}

#pragma mark- Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //        UIView *bgView = [cell viewWithTag:21];
    AnswerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell.radioButton.isSelected) {
        cell.radioButton.selected = YES;
        // TODO: call webservice to submit selected option
    }
}


#pragma mark - IBActions

- (IBAction)answerDidTap:(id)sender {
}

- (IBAction)nextButtonAction:(id)sender {
}

- (IBAction)previousButtonAction:(id)sender {
}

- (IBAction)resetButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
    
    //showDelegatedAlert with Title: @"Submit/End Quiz"
// And message:@"Are you sure you want to submit and end the quiz ?"
    // No and Yes will be buttons
}

@end
