//
//  QuizViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "QuizViewController.h"
#import "AnswerTableViewCell.h"
#import "ShowQuestionListView.h"
#import "DataModels.h"
#import "QuizResultViewController.h"

@interface QuizViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    NSString *studentID;
    NSString *quizID;
    NSString *questionIDs;
    
    NSInteger currentQuizIndex;
    QuizBaseClass *quizBaseObject;
    NSTimer *timer;
    NSDate *quizStartDateTime;
    double quizTime;
}

@property (strong, nonatomic) IBOutlet ShowQuestionListView *questionListView;



@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentQuizIndex = 1;
    [_tableViewQA setRowHeight:UITableViewAutomaticDimension];
    _tableViewQA.estimatedRowHeight = 44;
    
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];

    studentID = [_quizDict objectForKey:@"studentId"];
    quizID = [_quizDict objectForKey:@"quizId"];
    questionIDs = [_quizDict objectForKey:@"questionIds"];
    quizTime = [[_quizDict objectForKey:@"timeMinutes"] doubleValue];
    self.lblTime.text = [NSString stringWithFormat:@"%.2f",quizTime];

    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_GetQuizForCategoryUpdated]
     withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionIds":questionIDs, CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             quizBaseObject = [QuizBaseClass modelObjectWithDictionary:response];
             [_tableViewQA reloadData];
             
             timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];

             quizStartDateTime = [NSDate date];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

- (IBAction)popVCAction:(id)sender {

    [self submitButtonAction:nil];
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
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        
        UILabel *question = [cell viewWithTag:21];
        question.text = quesInfo.questionText;
        
        return cell;
    }
    else
    {
        AnswerTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        
        optionCell.radioButton.selected = NO;
        optionCell.viewOptionContainer.backgroundColor = [UIColor whiteColor];
        
        switch (indexPath.row)
        {
            case 1:
                optionCell.lblAnswer.text = quesInfo.option1;
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"A"]) {
                    
                    optionCell.radioButton.selected = YES;
                }
                
                break;
            case 2:
                optionCell.lblAnswer.text = quesInfo.option2;
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"B"]) {
                    
                    optionCell.radioButton.selected = YES;
                }
                
                break;
            case 3:
                optionCell.lblAnswer.text = quesInfo.option3;
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"C"]) {
                    
                    optionCell.radioButton.selected = YES;
                }
                
                break;
            case 4:
                optionCell.lblAnswer.text = quesInfo.option4;
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"D"]) {
                    
                    optionCell.radioButton.selected = YES;
                }
                
                break;
                
            default:
                break;
        }
        
        return optionCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return;
    }
    
    NSString *ontionMarked = @"";
    
    switch (indexPath.row)
    {
        case 1:
            ontionMarked = @"A";
            break;
        case 2:
            ontionMarked = @"B";
            break;
        case 3:
            ontionMarked = @"C";
            break;
        case 4:
            ontionMarked = @"D";
            break;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    
    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_SubmitQuestionAttempt]
     withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionId":quesInfo.questionId, @"optionMarked" : ontionMarked, @"correctOption" :quesInfo.correctOption}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             quesInfo.optionMarked = ontionMarked;
             [_tableViewQA reloadData];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

#pragma mark - IBActions

-(IBAction)showQuestionList {
    
    [self.questionListView removeFromSuperview];
    CGFloat x = ScreenWidth;
    self.questionListView.frame = CGRectMake(x, 64, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:self.questionListView];
    self.questionListView.vc = self;
    [self.questionListView reloadList:quizBaseObject.responseArray.count];
    self.questionListView.btn.alpha = 0.0;

    [UIView animateWithDuration:0.50 animations:^{
        self.questionListView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        self.questionListView.btn.alpha = 1.0;

    } completion:^(BOOL finished) {

    }];
}

-(void)selctedQuestionIndex:(NSInteger)index {
    
    currentQuizIndex = index;
    
    if (currentQuizIndex == 1) {
        _btnPrev.hidden = YES;
        _lblPrev.hidden = YES;
        
        _btnNext.hidden = NO;
        _lblNext.hidden = NO;
    }else if (currentQuizIndex == quizBaseObject.responseArray.count) {
        _btnNext.hidden = YES;
        _lblNext.hidden = YES;
        
        _btnPrev.hidden = NO;
        _lblPrev.hidden = NO;
    }else{
        _btnPrev.hidden = NO;
        _lblPrev.hidden = NO;
        
        _btnNext.hidden = NO;
        _lblNext.hidden = NO;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    _lblQuizTitle.text = quesInfo.moduleName;
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    [_tableViewQA reloadData];
}

- (IBAction)answerDidTap:(id)sender {
}

- (IBAction)nextButtonAction:(id)sender {
    
    currentQuizIndex++ ;
    
    if (currentQuizIndex == 2) {
        _btnPrev.hidden = NO;
        _lblPrev.hidden = NO;
    }
    
    if (currentQuizIndex == quizBaseObject.responseArray.count) {
        _btnNext.hidden = YES;
        _lblNext.hidden = YES;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    _lblQuizTitle.text = quesInfo.moduleName;
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    [_tableViewQA reloadData];
}

- (IBAction)previousButtonAction:(id)sender {
    
    currentQuizIndex-- ;
    
    if (currentQuizIndex == 1) {
        _btnPrev.hidden = YES;
        _lblPrev.hidden = YES;
    }
    
    if (currentQuizIndex == quizBaseObject.responseArray.count -1) {
        _btnNext.hidden = NO;
        _lblNext.hidden = NO;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    _lblQuizTitle.text = quesInfo.moduleName;
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    [_tableViewQA reloadData];
}

- (IBAction)resetButtonAction:(id)sender {
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    
    if (quesInfo.optionMarked == nil) {
        return;
    }
    
    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_clearQuestionAttempt]
     withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionId":quesInfo.questionId}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             quesInfo.optionMarked = nil;
             [_tableViewQA reloadData];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

- (IBAction)submitButtonAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Submit/End Quiz" message:@"Are you sure you want to submit and end the quiz ?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        [self submitQuiz];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)quizTimefinish {
    
    // dismiss all the previously presented vc, then show this alert
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Submit/End Quiz" message:@"Your time is finished." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        [self submitQuiz];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)submitQuiz {
    
    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_submitQuiz]
     withParameter:@{@"studentId":studentID, @"quizId":quizID}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             QuizResultViewController *vc = (QuizResultViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"QuizResultViewController" fromStoryboard:@"Home"];
             vc.quizDict = self.quizDict;
             
             NSMutableArray *vcArray = self.navigationController.viewControllers.mutableCopy;
             [vcArray removeLastObject];
             [vcArray removeLastObject];
             [vcArray addObject:vc];
             self.navigationController.viewControllers = vcArray;
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

-(void)updateTimerLabel {
    
    NSInteger time = -[quizStartDateTime timeIntervalSinceNow];
    
    self.lblTime.text = [NSString stringWithFormat:@"%02ld:%02ld",time/60,time % 60];
    
    if ( time >= quizTime*60) {//quizTime in min
        
        [timer invalidate];
        timer = nil;
        
        self.lblTime.text = [NSString stringWithFormat:@"%.2f",quizTime];
//        [self quizTimefinish];
        [self submitQuiz];

    }
}


@end
