//
//  InstructionViewController.m
//  ICAI
//
//  Created by Pardeep on 03/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "InstructionViewController.h"
#import "InstructionTableViewCell.h"
#import "QuizViewController.h"

@interface InstructionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableviewInstruction;

@property (weak, nonatomic) IBOutlet UITextView *txtView_instruction;

@end

@implementation InstructionViewController
@synthesize tableviewInstruction;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //SHADOW TO TABLE VIEW
    tableviewInstruction.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tableviewInstruction.layer.borderWidth = 1.0;
//    tableviewInstruction.layer.masksToBounds = NO;
//    tableviewInstruction.layer.shadowOffset = CGSizeMake(0, 0);
//    tableviewInstruction.layer.shadowRadius = 1;
//    tableviewInstruction.layer.shadowOpacity = 1.0;

    NSString *instruction = [_quizDict objectForKey:@"instruction"];
    self.txtView_instruction.text = instruction;
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- IBActions
- (IBAction)btnBeginAction:(UIButton *)sender {
    
    NSString *categoryID = [_quizDict objectForKey:@"categoryId"];

    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager]
                 callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:CHECK_IF_QUIZ_ACTIVE]
                 withParameter:@{@"categoryId":categoryID}
                 onCompletion:^(eResponseType responseType, id response)
                 {
                     [self hideProgressHudAfterDelay:0.1];
                     
                     if (responseType == eResponseTypeSuccessJSON)
                     {
                         NSDictionary *respDict = [response objectForKey:@"responseObject"];
                         
                         NSString *timeLeft = [respDict objectForKey:@"timerLeft"];
                         
                         if ([[[respDict objectForKey:@"quizStatus"] uppercaseString] isEqualToString:@"T"]) {
                             QuizViewController *vc = (QuizViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"QuizViewController" fromStoryboard:@"Home"];
                             vc.quizDict = self.quizDict;
                             vc.timeleftInms = timeLeft;
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                         else {
                             [self showAlert:@"The test hasn't started yet!"];
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


#pragma mark- TableView Datasource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InstructionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstructionTableViewCell"];
//    cell.labelTitle.text = @"test abc test abctyry abc test abc";
        cell.labelDetail.text = @"test abc test abc test abc test abc test abc test abc test abc test abc test abc test abc";
    return cell;
}

@end
