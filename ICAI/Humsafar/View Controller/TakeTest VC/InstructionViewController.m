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
    
    self.txtView_instruction.text = [NSString stringWithFormat:@"You need a stable internet connection to attempt this test.\n\nEvery answer marked will be auto-recorded.\n\nThis test consists of %ld questions.\n\nYou get +1 for every correct answer & -0.25 for every wrong answer. No marks will be deducted for not attempting a question.\n\nTotal test duration is %ld minutes.\n\nYou can submit the test by clicking on End Test or it will auto-submit if it times out.",[[_quizDict objectForKey:@"noOfQuestions"] integerValue],[[_quizDict objectForKey:@"timeMinutes"] integerValue]];
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
    
    QuizViewController *vc = (QuizViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"QuizViewController" fromStoryboard:@"Home"];
    vc.quizDict = self.quizDict;
    [self.navigationController pushViewController:vc animated:YES];
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
