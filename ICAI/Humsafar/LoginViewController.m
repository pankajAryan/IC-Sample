//
//  LoginViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UITextField+Validation.h"
#import "RootViewController.h"
#import "ForgotPassword.h"

#import "SecurityUtility.h"
#import "NSData+AES.h"

#import "SecurityUtil.h"
#import "GTMBase64.h"

//@interface LoginViewController () <GIDSignInDelegate, GIDSignInUIDelegate>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonForgotPassword;

//
//@property (weak, nonatomic) IBOutlet GIDSignInButton *GSignIn;
@end

NSString *encryptionKey =   @"2b9cYGfQ%D-^hnCB";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Login Actions
- (IBAction)btnForgotPasswordAction:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Enter your registered email Id"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"email";
     }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Submit"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *email = alertController.textFields.firstObject;
                                   [self resetPasswordWebserviceCall:email];
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                 style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction *action)
                                                 {
                                                     NSLog(@"Cancel action");
                                                 }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetPasswordWebserviceCall:(UITextField*)emailField {
    
    if (emailField.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
    else if (!emailField.isEmailValid) {
        [self showAlert:@"Invalid Email address!"];
    }
    else {
        [self showProgressHudWithMessage:@"Loading..."];

        [[FFWebServiceHelper sharedManager]
                         callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:Forgot_Password]
                         withParameter:@{@"user_email" : emailField.text}
                         onCompletion:^(eResponseType responseType, id response)
                         {
                             [self hideProgressHudAfterDelay:0.1];
                             
                             if (responseType == eResponseTypeSuccessJSON)
                             {
                                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                             }
                             else{
                                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                             }
                         }];
    }
}

- (IBAction)loginButtonDidTap:(id)sender {
    
    if (_txtFieldUsername.isEmptyField || _txtFieldPassword.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
    else if (!_txtFieldUsername.isEmailValid) {
        [self showAlert:@"Invalid Email address!"];
    }
    else {
        NSData *aesdataresult = [SecurityUtil encryptAESData:_txtFieldPassword.text];
        NSString *password = [SecurityUtil encodeBase64Data:aesdataresult];
        
        NSDictionary *paramsDict = @{@"user_email":_txtFieldUsername.text, @"user_password":password};
        
        [self showProgressHudWithMessage:@"SigningIn..."];

        [[FFWebServiceHelper sharedManager]
                callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:LOGIN]
                withParameter:paramsDict
                onCompletion:^(eResponseType responseType, id response)
                {
                    [self hideProgressHudAfterDelay:0.1];
                    
                    if (responseType == eResponseTypeSuccessJSON)
                    {
                        NSDictionary *dictUserdata = [response objectForKey:@"responseObject"];
                        
                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"application_id"] forKey:@"application_id"];
                        [UIViewController saveDatatoUserDefault:@"1" forKey:@"isUserLoggedIn"];

                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"student_name"] forKey:@"student_name"];
                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"student_email"] forKey:@"student_email"];
                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"gender"] forKey:@"gender"];
                        
                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"application_download"] forKey:@"application_download"];
                        
                        [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"payable_amount"] forKey:@"payable_amount"];

                        RootViewController *VC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
                        
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                    else {
                        if (responseType != eResponseTypeNoInternet)
                        {
                            //[self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                            [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                        }
                    }
                }];
    }
}

@end
