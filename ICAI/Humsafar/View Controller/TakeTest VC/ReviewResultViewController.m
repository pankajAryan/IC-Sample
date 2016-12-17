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
    // questionIds
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
