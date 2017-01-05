//
//  NotificationViewController.m
//  ICAI
//
//  Created by Pardeep on 02/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "UIViewController+RESideMenu.h"

@interface NotificationViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *notificationsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_menu;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_notificationsTableView setRowHeight:UITableViewAutomaticDimension];
    _notificationsTableView.estimatedRowHeight = 100;
    
    [self showProgressHudWithMessage:@"Loading..."];

    [[FFWebServiceHelper sharedManager]
                callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:GET_USER_ALERTS]
                withParameter:@{CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
                onCompletion:^(eResponseType responseType, id response)
                {
                    [self hideProgressHudAfterDelay:0.1];

                     if (responseType == eResponseTypeSuccessJSON)
                     {
                         notificationsArray = [response objectForKey:@"responseObject"];
                         [_notificationsTableView reloadData];
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
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notificationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    
    NSDictionary *notificationObject = [notificationsArray objectAtIndex:indexPath.row];
    
    cell.labelQuestionTitle.text = [notificationObject objectForKey:@"title"];
    cell.labelQuestionDetail.text = [notificationObject objectForKey:@"message"];
    cell.labelDate.text = [notificationObject objectForKey:@"date"];

    return cell;
}



@end
