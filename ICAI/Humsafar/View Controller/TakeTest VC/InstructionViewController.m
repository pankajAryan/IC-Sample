//
//  InstructionViewController.m
//  ICAI
//
//  Created by Pardeep on 03/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "InstructionViewController.h"
#import "InstructionTableViewCell.h"

@interface InstructionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableviewInstruction;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- IBActions
- (IBAction)btnBeginAction:(UIButton *)sender {
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
