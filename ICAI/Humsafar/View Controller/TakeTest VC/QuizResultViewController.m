//
//  QuizResultViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 16/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "QuizResultViewController.h"
#import "ReviewResultViewController.h"

@interface QuizResultViewController ()

@end

@implementation QuizResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *quizID = [_quizDict objectForKey:@"quizId"];
    NSString *studentID = [_quizDict objectForKey:@"studentId"];
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager]
             callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:QUIZ_RESULT]
             withParameter:@{@"studentId":studentID, @"quizId":quizID, CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
             onCompletion:^(eResponseType responseType, id response)
             {
                 [self hideProgressHudAfterDelay:0.1];
                 
                 if (responseType == eResponseTypeSuccessJSON)
                 {
                     self.lblname.text = [NSString stringWithFormat:@"Hi %@",[UIViewController retrieveDataFromUserDefault:@"student_name"]];

                     NSDictionary *quizResultInfo = [response objectForKey:@"responseObject"];
                     
                     _lblCorrect.text = [quizResultInfo objectForKey:@"correct"];
                     _lblIncorrect.text = [quizResultInfo objectForKey:@"incorrect"];
                     _lblUnattempted.text = [quizResultInfo objectForKey:@"notAttempted"];
                     _lblScore.text = [quizResultInfo objectForKey:@"score"];
                 }
                 else if (responseType == eResponseTypeFailJSON){
                     [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                 }
                 else if (responseType != eResponseTypeNoInternet)
                     [self showAlert:@"Something went wrong, Please try after sometime."];
             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewAttempDetails:(id)sender {
    
    ReviewResultViewController *vc = (ReviewResultViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"ReviewResultViewController" fromStoryboard:@"Other"];
    vc.quizDict = self.quizDict;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
