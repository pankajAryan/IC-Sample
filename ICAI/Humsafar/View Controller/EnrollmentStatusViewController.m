//
//  EnrollmentStatusViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 11/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "EnrollmentStatusViewController.h"

@interface EnrollmentStatusViewController () {
    
    NSDictionary *paymentStatusDict;
}
@property (weak, nonatomic) IBOutlet UIView *frontView;

@property (weak, nonatomic) IBOutlet UILabel *lblApplicationId;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPayStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPayStatus;

@property (weak, nonatomic) IBOutlet UIView *viewPaymentContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblPayAmount;
@property (weak, nonatomic) IBOutlet UIButton *buttonMakePayment;

@end

@implementation EnrollmentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showProgressHudWithMessage:@"Please wait.."];

    [[FFWebServiceHelper sharedManager]
                     callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:@"studentappgetpaymentstatus"]
                     withParameter:@{@"application_id" : @"10015961"}
                     onCompletion:^(eResponseType responseType, id response)
                     {
                         [self hideProgressHudAfterDelay:0.1];
                         
                         if (responseType == eResponseTypeSuccessJSON)
                         {
                             paymentStatusDict = [response objectForKey:@"responseObject"];
                             
                             _lblApplicationId.text = [paymentStatusDict objectForKey:@"application_id"];
                             _lblName.text = [paymentStatusDict objectForKey:@"application_id"];
                             _lblEmail.text = [paymentStatusDict objectForKey:@"application_id"];
                             _lblPayStatus.text = [paymentStatusDict objectForKey:@"payment_status"];
                             
                             if ([_lblPayStatus.text compare:@"SUCCESS" options:NSCaseInsensitiveSearch] == NSOrderedSame ) {
                                 
                                 _imgViewPayStatus.image = [UIImage imageNamed:@"cross"];
                             }
                             
                             _frontView.hidden = YES;
                         }
                         else {
                             [self showAlert:@"Something went wrong, Please try after sometime."];
                         }
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)makePaymentAction:(id)sender {
}

@end
