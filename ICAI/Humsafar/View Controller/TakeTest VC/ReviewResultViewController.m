//
//  ReviewResultViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 17/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ReviewResultViewController.h"
#import "AnswerTableViewCell.h"
#import "DataModels.h"

@interface ReviewResultViewController () <UITableViewDataSource> {
    
    NSInteger currentQuizIndex;
    QuizBaseClass *quizBaseObject;
}

@end

@implementation ReviewResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentQuizIndex = 1;
    [_tableViewQA setRowHeight:UITableViewAutomaticDimension];
    _tableViewQA.estimatedRowHeight = 44;
    
    _lblQuizNumber.text = [NSString stringWithFormat:@"%li/%@",currentQuizIndex,[_quizDict objectForKey:@"noOfQuestions"]];
    
    NSString *studentID = [_quizDict objectForKey:@"studentId"];
    NSString *quizID = [_quizDict objectForKey:@"quizId"];
    NSString *questionIDs = [_quizDict objectForKey:@"questionIds"];
    
    [self showProgressHudWithMessage:@"Loading..."];
    
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
                     else if (responseType == eResponseTypeFailJSON){
                         [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                     }
                     else if (responseType != eResponseTypeNoInternet)
                         [self showAlert:@"Something went wrong, Please try after sometime."];
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
    
    QuesInfoObject *quesInfo = [quizBaseObject.responseArray objectAtIndex:currentQuizIndex-1];

    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        
        UITextView *question = [cell viewWithTag:21];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [quesInfo.questionText dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        question.attributedText = attributedString;
        
        return cell;
    }
    else
    {
        AnswerTableViewCell *optionCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
        
        optionCell.radioButton.selected = NO;
        optionCell.viewOptionContainer.backgroundColor = [UIColor whiteColor];
        
        NSString *strQUestion = @"";
        
        switch (indexPath.row)
        {
            case 1:
                strQUestion = quesInfo.option1;
                
                if ([quesInfo.correctOption.uppercaseString isEqualToString:@"A"]) {
                    optionCell.viewOptionContainer.backgroundColor = [UIColor greenBGColor];
                }
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"A"]) {
                    
                    optionCell.radioButton.selected = YES;
                    
                    if (![quesInfo.optionMarked isEqualToString:quesInfo.correctOption]) {
                        optionCell.viewOptionContainer.backgroundColor = [UIColor redBGColor];
                    }
                }

                break;
            case 2:
                strQUestion = quesInfo.option2;
                
                if ([quesInfo.correctOption.uppercaseString isEqualToString:@"B"]) {
                    optionCell.viewOptionContainer.backgroundColor = [UIColor greenBGColor];
                }
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"B"]) {
                    
                    optionCell.radioButton.selected = YES;
                    
                    if (![quesInfo.optionMarked isEqualToString:quesInfo.correctOption]) {
                        optionCell.viewOptionContainer.backgroundColor = [UIColor redBGColor];
                    }
                }
                
                break;
            case 3:
                strQUestion = quesInfo.option3;
                
                if ([quesInfo.correctOption.uppercaseString isEqualToString:@"C"]) {
                    optionCell.viewOptionContainer.backgroundColor = [UIColor greenBGColor];
                }
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"C"]) {
                    
                    optionCell.radioButton.selected = YES;
                    
                    if (![quesInfo.optionMarked isEqualToString:quesInfo.correctOption]) {
                        optionCell.viewOptionContainer.backgroundColor = [UIColor redBGColor];
                    }
                }
                
                break;
            case 4:
                strQUestion = quesInfo.option4;
                
                if ([quesInfo.correctOption.uppercaseString isEqualToString:@"D"]) {
                    optionCell.viewOptionContainer.backgroundColor = [UIColor greenBGColor];
                }
                
                if ([quesInfo.optionMarked.uppercaseString isEqualToString:@"D"]) {
                    
                    optionCell.radioButton.selected = YES;
                    
                    if (![quesInfo.optionMarked isEqualToString:quesInfo.correctOption]) {
                        optionCell.viewOptionContainer.backgroundColor = [UIColor redBGColor];
                    }
                }
                
                break;
   
            default:
                break;
        }
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [strQUestion dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        optionCell.txtViewAnswer.attributedText = attributedString;
        
        return optionCell;
    }
}


#pragma mark - IBActions

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



@end
