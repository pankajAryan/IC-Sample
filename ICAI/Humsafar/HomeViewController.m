//
//  HomeViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+RESideMenu.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn_menu;
@property (strong, nonatomic) NSString *navType;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;

@property (weak, nonatomic) IBOutlet UIView *incentiveView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_incentiveAmount;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
        [self fetchDistrictListForStateId:@"29"];//Hardcode
        self.incentiveView.hidden = YES;
    }else{
        [self.alertBtn setBackgroundImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
        [self fetchWalletBalanceForUserFromServer];
        self.incentiveView.hidden = NO;
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)fetchWalletBalanceForUserFromServer {
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetIncentiveWalletBalanceForUser withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            self.lbl_incentiveAmount.text = [NSString stringWithFormat:@"%@",response[@"responseObject"]];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
}

- (void)fetchDistrictListForStateId:(NSString*)stateId {
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId" : stateId} onCompletion:^(eResponseType responseType, id response) {
        
        @try {
            if (responseType == eResponseTypeSuccessJSON) {
                NSArray *arrayDistricts = [response objectForKey:kKEY_ResponseObject];
                if (arrayDistricts != nil) {
                    [UIViewController saveDatatoUserDefault:arrayDistricts forKey:@"districts"];
                }
            }else{
                
            }
        } @catch (NSException *exception) {
            
        }
        
    }];
}


@end
