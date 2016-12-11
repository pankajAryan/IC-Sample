//
//  EnrollmentStatusViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 11/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "EnrollmentStatusViewController.h"

@interface EnrollmentStatusViewController ()
{
    PGMerchantConfiguration *objMerchant;
    NSMutableDictionary *orderDict;
    NSString *enrolmentId;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonMakePayment;

@end

@implementation EnrollmentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    enrolmentId = @"";
    //label_productTitle.text = ([self.dictProductInfo objectForKey:@"productTitle"]!=nil)?[self.dictProductInfo objectForKey:@"productTitle"]:@"";
    //textVw_productDescription.text = ([self.dictProductInfo objectForKey:@"description"]!=nil)?[self.dictProductInfo objectForKey:@"description"]:@"";
    //label_productPrice.text = ([self.dictProductInfo objectForKey:@"productPrice"]!=nil)?[NSString stringWithFormat:@"Rs %@",[self.dictProductInfo objectForKey:@"productPrice"]]:@"";
    
    NSLog(@"%@",_dictProductInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVCAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)makePaymentAction:(id)sender {
    NSString *application_id   = [self.dictProductInfo objectForKey:@"application_id"];
    [self showPaytmKaroWithInfo:@{@"application_id":application_id}];
}


#pragma mark - Paytm Delegates

-(void)didSucceedTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    NSString *amount = [self.dictProductInfo objectForKey:@"txn_amount"];
    NSString *orderId = [self.dictProductInfo objectForKey:@"ORDERID"];
    NSString *status = @"";
    NSString *payment_txnid = @"";
    NSString *bankTransactionId = [response objectForKey:@"BANKTXNID"];
    NSString *bankResponseCode = [response objectForKey:@"RESPCODE"];
    NSString *bankResponseMessage = [response objectForKey:@"RESPMSG"];
    NSString *payment_mode = @"PAYTM";
    NSString *currency = @"";
    
    [self showProgressHudWithMessage:@"Please wait..."];
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:Payment_AppPaymentStatus]withParameter:@{@"txn_amount":amount,@"icai_transaction_id":orderId,@"status":status,@"payment_txnid":payment_txnid,@"bankTransactionId":bankTransactionId,@"gateway_response_code":bankResponseCode,@"gateway_response_msg":bankResponseMessage,@"payment_mode":payment_mode,@"txn_currency":currency}
     onCompletion:^(eResponseType responseType, id response)
     {
         @try {
             [self hideProgressHudAfterDelay:0.1];
             if (responseType == eResponseTypeSuccessJSON)
             {
                 if ([[response objectForKey:@"errorCode"] integerValue] == 0) {
                     //unlock product
                     [self showAlert:[response objectForKey:@"Product purchased successfully!"]];

                 }else{
                     [self showAlert:[response objectForKey:@"Error submitting payment! Please try after sometime."]];
                 }
             }
             else{
                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
             }
         } @catch (NSException *exception) {
             
         }
     }];
    
    [self removeController:controller];
}

-(void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    [self removeController:controller];
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"" message:[response objectForKey:@"RESPMSG"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
}

-(void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    [self removeController:controller];
}

-(void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    
}

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil){
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}


-(void)showPaytmKaroWithInfo:(NSDictionary*)dict{
    __weak __typeof(self)weakSelf = self;
    // Do any additional setup after loading the view.
    [self showProgressHudWithMessage:@"Please wait..."];
    //requestInitiatePaymentWithParameters
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:Payment_AppRepay]
     withParameter:dict
     onCompletion:^(eResponseType responseType, id response)
     {
         @try {
             [self hideProgressHudAfterDelay:0.1];
             if (responseType == eResponseTypeSuccessJSON)
             {
                 if ([[response objectForKey:@"errorCode"] integerValue] == 0 && [[[response objectForKey:@"responseObject"] objectForKey:@"paymentInitiationStatus"] isEqualToString:@"SUCCESS"]) {
                     NSString *strOrderId = (NSString*)[[response objectForKey:@"responseObject"] objectForKey:@"icai_transaction_id"];
                     NSString *strAmount = (NSString*)[[response objectForKey:@"responseObject"] objectForKey:@"payable_amount"];
                     //set flags that payment is initiated for particular product-id
                     //and
                     //call payment with info to pay to paytm
                     [self.dictProductInfo setObject:strAmount forKey:@"txn_amount"];
                     [self.dictProductInfo setObject:strAmount forKey:@"ORDERID"];
                     [weakSelf callPaymentWithOrderId:strOrderId andAmount:strAmount];
                 }else{
                     [self showAlert:[response objectForKey:@"Error initiating payment! Please try after sometime."]];
                 }
             }
             else{
                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
             }
         } @catch (NSException *exception) {
             
         }
     }];
}

-(void)callPaymentWithOrderId:(NSString*)orderId andAmount:(NSString*)amount{
    //Paytm Integration working
    
    //Step 1: Create a default merchant config object
    objMerchant = [PGMerchantConfiguration defaultConfiguration];
    objMerchant.clientSSLCertPath = NULL;
    objMerchant.clientSSLCertPassword = NULL;
    
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    objMerchant.checksumGenerationURL = kChecksumGenerationURL;
    objMerchant.checksumValidationURL = kChecksumValidationURL;
    
    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[@"CHANNEL_ID"] = kCHANNELID;
    orderDict[@"INDUSTRY_TYPE_ID"] = kINDUSTRYTYPEID;
    orderDict[@"WEBSITE"] = kWEBSITE;
    orderDict[@"THEME"] = kTHEME;
    orderDict[@"REQUEST_TYPE"] = kREQUESTTYPE;
    
    NSString *strUserId     = [UIViewController retrieveDataFromUserDefault:@"userid"];
    NSString *strAmount     = amount;
    
    if (strUserId == nil || strAmount == nil) {
        return;
    }
    
    //Order configuration in the order object
    orderDict[@"MID"]           = kMID;
    orderDict[@"ORDER_ID"]      = orderId;
    orderDict[@"CUST_ID"]       = strUserId;
    orderDict[@"TXN_AMOUNT"]    = [NSString stringWithFormat:@"%0.2f",[strAmount floatValue]];
    orderDict[@"EMAIL"]         = kEMAIL;
    orderDict[@"MOBILE_NO"]     = kMOBILENO;
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.useStaging = true;
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = objMerchant;
    txnController.topBar = self.navigationController.navigationBar;
//    button_cancelPaytm = [UIButton buttonWithType:UIButtonTypeCustom];
//    button_cancelPaytm.frame = CGRectMake(-7, 10, 33, 33);
//    [button_cancelPaytm setImage:[UIImage imageNamed:@"prev_arrow"] forState:UIControlStateNormal];
//    //[view_toolbar addSubview:button_cancelPaytm];
//    txnController.cancelButton = button_cancelPaytm;
    txnController.topBar = nil;//view_toolbar;
    txnController.delegate = self;
    
    [self showController:txnController];
}


- (IBAction)action_cancelPayment:(id)sender{
    [self removeController:sender];
}



@end
