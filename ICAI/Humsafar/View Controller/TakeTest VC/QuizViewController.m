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
    NSInteger visibleCounter;

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
    
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",(long)currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];

    studentID = [_quizDict objectForKey:@"studentId"];
    quizID = [_quizDict objectForKey:@"quizId"];
    questionIDs = [_quizDict objectForKey:@"questionIds"];
    
    quizTime = [_timeleftInms integerValue]/60000.00;
    [self updateTimerLabel];
    
    quizBaseObject = [QuizBaseClass modelObjectWithDictionary:self.questionsDict];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
    
    quizStartDateTime = [NSDate date];
    
    [self initializeVisibleCounter];
    
//    [_tableViewQA reloadData];
    
    //
    CGFloat x = ScreenWidth;
    self.questionListView.frame = CGRectMake(x, 64, ScreenWidth, ScreenHeight-64);
    [self.view addSubview:self.questionListView];
    self.questionListView.vc = self;
    //
    
    [[NSNotificationCenter defaultCenter]
                                 addObserver:self
                                 selector:@selector(applicationDidBecomeActive)
                                 name:UIApplicationDidBecomeActiveNotification
                                 object:NULL];
}

- (void)applicationDidBecomeActive
{
    NSString *categoryID = [_quizDict objectForKey:@"categoryId"];
    
//    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:CHECK_IF_QUIZ_ACTIVE]
     withParameter:@{@"categoryId":categoryID}
     onCompletion:^(eResponseType responseType, id response)
     {
//         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             NSDictionary *respDict = [response objectForKey:@"responseObject"];
             
             if ([[[respDict objectForKey:@"quizStatus"] uppercaseString] isEqualToString:@"T"]) {
                 // update timer value with timeLeft value
                 _timeleftInms = [respDict objectForKey:@"timerLeft"];
                 quizTime = [_timeleftInms integerValue]/60000.00;
                 [self updateTimerLabel];
             }
             else {
                 // SUBMIT THE QUIZ
                 [self quizTimefinish];
             }
         }
//         else if (responseType == eResponseTypeFailJSON){
//             [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
//         }
//         else{
//             [self showAlert:@"Something went wrong, Please try after sometime."];
//         }
     }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // technically these timers retain self so there's a cycle but
    // we're a singleton anyway.
    [timer invalidate];
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
    return (visibleCounter != 0) ? 5 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    
    if([quesInfo.isFreezed isEqualToString:@"T"])
    {
        _resetButton.enabled = NO;
    }
    else
        _resetButton.enabled = YES;

    
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

    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];

    if ((indexPath.row == 0) || ([quesInfo.isFreezed isEqualToString:@"T"])) {
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
    
    NSString *categoryID = [_quizDict objectForKey:@"categoryId"];
    NSString *isToBeFreezed = [self checkIfQuestionToBeFreezed];
    
    [self showProgressHudWithMessage:@"Loading..."];

    [[FFWebServiceHelper sharedManager]
             callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_SubmitQuestionAttempt]
             withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionId":quesInfo.questionId, @"optionMarked" : ontionMarked, @"correctOption" :quesInfo.correctOption, @"categoryId":categoryID, @"studentSessionId":quizBaseObject.studentSessionId, @"isFreezed": isToBeFreezed}
             onCompletion:^(eResponseType responseType, id response)
             {
                 [self hideProgressHudAfterDelay:0.1];
                 
                 if (responseType == eResponseTypeSuccessJSON)
                 {
                     // update timer value with timeLeft value
//                     NSDictionary *respDict = [response objectForKey:@"responseObject"];
//                     _timeleftInms = [respDict objectForKey:@"timerLeft"];
//                     quizTime = [_timeleftInms integerValue]/60000.00;
//                     [self updateTimerLabel];
                     
                     [self showSuccessTSMessage:@"Option marked successfully."];
                     quesInfo.optionMarked = ontionMarked;
                     quesInfo.isFreezed = isToBeFreezed;
                     
                     [_tableViewQA reloadData];
                     
                     if(quizBaseObject.responseArray.count/20 <= [self getAttemptedCount])
                     {
                         if(visibleCounter < quizBaseObject.responseArray.count)
                         {
                             visibleCounter += quizBaseObject.responseArray.count/5;
                             
                             if(currentQuizIndex != quizBaseObject.responseArray.count)
                             {
                                 _btnNext.hidden = NO;
                                 _lblNext.hidden = NO;
                             }
                         }
                     }
                 }
                 else if (responseType == eResponseTypeFailJSON){
                     [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                 }
                 else{
                     [self showAlert:@"Something went wrong, Please try after sometime."];
                 }
             }];
}

#pragma Mark - Question Part display & Freeze logic methods

- (NSString*)checkIfQuestionToBeFreezed {
    
    int slot = 0;
    
    switch((currentQuizIndex-1)/(quizBaseObject.responseArray.count/5))
    {
        case 0:
            slot = 0;
            break;
        case 1:
            slot = 1;
            break;
        case 2:
            slot = 2;
            break;
        case 3:
            slot = 3;
            break;
        case 4:
            slot = 4;
            break;
    }
    
    int maxFreezed = quizBaseObject.responseArray.count/20;
    int slotSize= quizBaseObject.responseArray.count/5;
    int markedCounter = 0;
    for(int i=slot*slotSize;i<(slot+1)*slotSize;i++)
    {
        QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:i];
        
        if (quesInfo.optionMarked != nil) {
            ++markedCounter;
        }
    }
    
    if(markedCounter < maxFreezed)
    {
        return @"T";
    }
    else
    {
        return @"F";
    }
}

- (int)getAttemptedCount {

    int startIndex = 0;
    
    if(visibleCounter == quizBaseObject.responseArray.count/5)
    {
        startIndex = 0;
    }
    else
    {
        startIndex = visibleCounter - (quizBaseObject.responseArray.count/5);
    }
    
    int attempted = 0;
    for(int i=startIndex;i<visibleCounter;i++)
    {
        QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:i];

        if (quesInfo.optionMarked != nil) {
            ++attempted;
        }
    }
    
    return attempted;
}

- (void)initializeVisibleCounter {
    
    visibleCounter = quizBaseObject.responseArray.count/5;

    while([self getAttemptedCount] >= quizBaseObject.responseArray.count/20)
    {
        if(visibleCounter < quizBaseObject.responseArray.count)
        {
            visibleCounter+= quizBaseObject.responseArray.count/5;
        }
        else
        {
            break;
        }
    }
}

#pragma mark - IBActions

-(IBAction)showHideQuestionList:(UIButton*)sender {

    if (sender.selected) {
        [self hideQuestionList];
    }else{
        [self showQuestionList];
    }
}

-(void)showQuestionList {
    
    self.showListBtn.selected = YES;
    [self.questionListView reloadList:[quizBaseObject.responseArray subarrayWithRange:NSMakeRange(0, visibleCounter)]];
    self.questionListView.btn.alpha = 0.0;
    
    [UIView animateWithDuration:0.50 animations:^{
        self.questionListView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        self.questionListView.btn.alpha = 1.0;
    } completion:nil];
}

-(void)hideQuestionList {

    self.showListBtn.selected = NO;
    self.questionListView.btn.alpha = 1.0;
    [UIView animateWithDuration:0.50 animations:^{
        self.questionListView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth, ScreenHeight-64);
        self.questionListView.btn.alpha = 0.0;
    } completion:nil];
}

-(void)selctedQuestionIndex:(NSInteger)index {
    
    currentQuizIndex = index;
    
    if (currentQuizIndex == 1) {
        _btnPrev.hidden = YES;
        _lblPrev.hidden = YES;
        
        _btnNext.hidden = NO;
        _lblNext.hidden = NO;
    }else if (currentQuizIndex == visibleCounter) {
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
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",(long)currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
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
    
    if (currentQuizIndex == visibleCounter) {
        _btnNext.hidden = YES;
        _lblNext.hidden = YES;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    _lblQuizTitle.text = quesInfo.moduleName;
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",(long)currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    [_tableViewQA reloadData];
}

- (IBAction)previousButtonAction:(id)sender {
    
    currentQuizIndex-- ;
    
    if (currentQuizIndex == 1) {
        _btnPrev.hidden = YES;
        _lblPrev.hidden = YES;
    }
    
    if (currentQuizIndex == visibleCounter -1) {
        _btnNext.hidden = NO;
        _lblNext.hidden = NO;
    }
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    _lblQuizTitle.text = quesInfo.moduleName;
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",(long)currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    [_tableViewQA reloadData];
}

- (IBAction)resetButtonAction:(id)sender {
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];
    
    if (quesInfo.optionMarked == nil) {
        return;
    }
    
    [self showProgressHudWithMessage:@"Loading..."];
    
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
         else if (responseType == eResponseTypeFailJSON){
             [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
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
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_submitQuiz]
     withParameter:@{@"studentId":studentID, @"quizId":quizID}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             NSString *isSessionValid = [[response objectForKey:@"responseObject"] objectForKey:@"isSessionValid"];
             
             if ([isSessionValid.uppercaseString isEqualToString:@"F"]) {
                 [self showAlert:@"User can't be logged into 2 devices simultaneously."];
             }
             else {
                 [self showAlert:@"You have successfully submitted the quiz."];
                 
                 NSMutableArray *vcArray = self.navigationController.viewControllers.mutableCopy;
                 
                 if ([[[_quizDict objectForKey:@"isPaid"] uppercaseString] isEqualToString:@"T"]) {
                     
                     [[NSNotificationCenter defaultCenter] removeObserver:self];
                     // technically these timers retain self so there's a cycle but
                     // we're a singleton anyway.
                     [timer invalidate];
                     
                     QuizResultViewController *vc = (QuizResultViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"QuizResultViewController" fromStoryboard:@"Home"];
                     vc.quizDict = self.quizDict;
                     
                     [vcArray removeLastObject];
                     [vcArray removeLastObject];
                     [vcArray addObject:vc];
                     self.navigationController.viewControllers = vcArray;
                 }
                 else
                     [self.navigationController popToViewController:[vcArray objectAtIndex:vcArray.count-3] animated:YES];
             }
         }
         else if (responseType == eResponseTypeFailJSON){
             [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

-(void)updateTimerLabel {
    
    NSInteger time = quizTime*60 + [quizStartDateTime timeIntervalSinceNow];
    
    self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d",time/60,time % 60];
    
    if ( time <= 0) {//quizTime in min
        
        [timer invalidate];
        timer = nil;
        
        self.lblTime.text = [NSString stringWithFormat:@"00:00"];
        [self submitQuiz];
    }
}


@end
