//
//  HomeViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+RESideMenu.h"
#import "HomeCollectionViewCell.h"
#import "TestListViewController.h"
#import "RegisterViewController.h"

#import "SecurityUtil.h"

@interface HomeViewController ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_menu;
@property (strong, nonatomic) NSString *navType;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UIView *incentiveView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_incentiveAmount;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];

    [[FFWebServiceHelper sharedManager]
             callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:UPDATE_APNS_ID]
             withParameter:@{@"applicationId":applicationId, CHECKSOURCE_KEY:CHECKSOURCE_VALUE, @"deviceOS":@"iOS", @"notificationId":@""}
             onCompletion:^(eResponseType responseType, id response)
             {
                 NSDecimalNumber * latestVersion = [NSDecimalNumber decimalNumberWithString:[response objectForKey:@"responseObject"]];
                 NSDecimalNumber * currentVersion = [NSDecimalNumber decimalNumberWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

                 if ([currentVersion compare:latestVersion] == NSOrderedAscending) {
                     [self showAlert:@"Please update your app to newer version from the app store."];
                 }
             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)myProfileButtonAction:(id)sender {
    
    RegisterViewController *vc = [RegisterViewController instantiateViewControllerWithIdentifier:@"RegisterViewController" fromStoryboard:@"Main"];
    vc.applicationID = [UIViewController retrieveDataFromUserDefault:@"application_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)takeTestAction:(id)sender {
    
    TestListViewController *vc = (TestListViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"TestListViewController" fromStoryboard:@"Home"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)applicationFormDidTap:(id)sender {
    
    NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];
    NSString *urlString = [UIViewController retrieveDataFromUserDefault:@"application_download"];
    
    if (!urlString) {
        urlString = [NSString stringWithFormat:@"%@%@",Application_Form_Download,[SecurityUtil encryptMD5String:applicationId]];
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
}

@end
