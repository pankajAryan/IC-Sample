//
//  QuizViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 15/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation QuizViewController

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
    
    if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        
       // UILabel *question = [cell viewWithTag:21];
        //question.text = ;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        
//        UIView *bgView = [cell viewWithTag:21];
//        UIButton *radioButton = [cell viewWithTag:22];
//        UILabel *answer = [cell viewWithTag:23];
        
    }
    
    return cell;
}

#pragma mark- Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma mark - IBActions


- (IBAction)nextButtonAction:(id)sender {
}

- (IBAction)previousButtonAction:(id)sender {
}

- (IBAction)resetButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
}

@end
