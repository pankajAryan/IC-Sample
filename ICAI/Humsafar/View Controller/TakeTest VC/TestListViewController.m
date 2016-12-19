//
//  TestListViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "TestListViewController.h"
#import "TestListTableViewCell.h"
#import "InstructionViewController.h"
#import "QuizResultViewController.h"

@interface TestListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView_TestList;

@end

@implementation TestListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:GET_QUIZZES]
     withParameter:@{@"studentId":applicationId,@"categoryId":@"1",@"source":@"app",CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             arrayTestList = [response objectForKey:@"responseObject"];
             
             [_tableView_TestList reloadData];
         }
         else{
             [self showAlert:@"Something went wrong, Please try after sometime."];
         }
     }];
}

- (IBAction)testDesignatedAction:(id)sender {
    
    NSDictionary *testObject = [arrayTestList objectAtIndex:[sender tag]];
//{"quizId":"1","isAttempted":"F","studentId":"15963","questionIds":"26,3,8,20,9,17,31,1,5,32,13,12,2,15,37,28,29,34,27,16,36,7,11,24,38,18,30,25,39,23,22,21,10,40,19,6,33,35,14,4","noOfQuestions":"40","timeMinutes":"30"}
    
    if ([[testObject objectForKey:@"isAttempted"] compare:@"T" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            // View Score flow
        QuizResultViewController *vc = (QuizResultViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"QuizResultViewController" fromStoryboard:@"Home"];
        vc.quizDict = testObject;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {  // Take Test flow
        InstructionViewController *vc = (InstructionViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"InstructionViewController" fromStoryboard:@"Home"];
        vc.quizDict = testObject;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    return arrayTestList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestListTableViewCell"];
    
    NSDictionary *testObject = [arrayTestList objectAtIndex:indexPath.row];
    
    cell.lblTestTitle.text = [NSString stringWithFormat:@"Test Number: %li",indexPath.row+1];
    cell.lblQuesCount.text = [NSString stringWithFormat:@"Number of questions: %@",[testObject objectForKey:@"noOfQuestions"]];
    cell.lblDuration.text = [NSString stringWithFormat:@"Duration: %@ minutes",[testObject objectForKey:@"timeMinutes"]];
    
    if ([[testObject objectForKey:@"isAttempted"] compare:@"T" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [cell.buttonTestAction setTitle:@"View Score" forState:UIControlStateNormal];
    }
    else {
        [cell.buttonTestAction setTitle:@"Take Test" forState:UIControlStateNormal];
    }
    
    cell.buttonTestAction.tag = indexPath.row;
    
    return cell;
}

#pragma mark- Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 94;
}

@end
