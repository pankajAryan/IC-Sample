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

#pragma mark - UIColleciton view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];

    NSString *imageName, *text;
    switch (indexPath.item) {
        case 0:
            imageName = @"User";
            text = @"My Profile";
            break;
        case 1:
            imageName = @"Payment";
            text = @"Payment";
            break;
        case 2:
            imageName = @"TestTask";
            text = @"Test Task";
            break;
        case 3:
            imageName = @"ApplicationForm";
            text = @"Application Form";
            break;
            
        default:
            break;
    }
    [cell configCellWithImage:imageName labelText:text];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
}

@end
