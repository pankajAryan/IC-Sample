//
//  ReviewResultViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 17/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ReviewResultViewController.h"
#import "AnswerTableViewCell.h"

@interface ReviewResultViewController () <UITableViewDataSource>

@end

@implementation ReviewResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_tableViewQA setRowHeight:UITableViewAutomaticDimension];
    _tableViewQA.estimatedRowHeight = 44;
    
    NSString *studentID = [_quizDict objectForKey:@"studentId"];
    NSString *quizID = [_quizDict objectForKey:@"quizId"];
    NSString *questionIDs = [_quizDict objectForKey:@"questionIds"];
    
    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
                 callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_ATTEMPT]
                 withParameter:@{@"studentId":studentID, @"quizId":quizID, @"questionIds":questionIDs, CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
                 onCompletion:^(eResponseType responseType, id response)
                 {
                     [self hideProgressHudAfterDelay:0.1];
                     
                     if (responseType == eResponseTypeSuccessJSON)
                     {
                         NSDictionary *quizResultInfo = [response objectForKey:@"responseObject"];
                         
//                         _lblCorrect.text = [quizResultInfo objectForKey:@"correct"];
//                         _lblIncorrect.text = [quizResultInfo objectForKey:@"incorrect"];
//                         _lblUnattempted.text = [quizResultInfo objectForKey:@"notAttempted"];
//                         _lblScore.text = [quizResultInfo objectForKey:@"score"];
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
    return 5;
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
        
        optionCell.viewOptionContainer.backgroundColor = [UIColor colorFromHexString:@""];
//        Red color code
//        e74c3c
//        
//        Green color code
//        2ecc71
        
        return optionCell;
    }
    
    return cell;
}


#pragma mark - IBActions

- (IBAction)nextButtonAction:(id)sender {
}

- (IBAction)previousButtonAction:(id)sender {
}



@end
