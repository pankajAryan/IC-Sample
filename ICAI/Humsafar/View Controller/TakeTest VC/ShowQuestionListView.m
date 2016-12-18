//
//  ShowQuestionListView.m
//  ICAI
//
//  Created by Rahul on 12/17/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ShowQuestionListView.h"

@interface ShowQuestionListView ()<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) NSInteger questionCount;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation ShowQuestionListView

-(void)reloadList:(NSInteger)questionCount{
    
    self.questionCount = questionCount;
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [UIView new];
    [self.tblView reloadData];
}
- (IBAction)tapOnBtn:(UIButton *)sender {
    
    [self.vc hideQuestionList];
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qcList"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qcList"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    [self.vc selctedQuestionIndex:indexPath.row+1];
    [self.vc hideQuestionList];
}




@end
