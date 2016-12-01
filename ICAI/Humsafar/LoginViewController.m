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


//@interface LoginViewController () <GIDSignInDelegate, GIDSignInUIDelegate>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonForgotPassword;

//
//@property (weak, nonatomic) IBOutlet GIDSignInButton *GSignIn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonForgotPassword.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Login Actions

- (IBAction)loginButtonDidTap:(id)sender {
    
    if (_txtFieldUsername.isEmptyField || _txtFieldPassword.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
//    else if (!_txtFieldUsername.isEmailValid) {
//        [self showAlert:@"Invalid Email address!"];
//    }
    else {
        
        NSDictionary *paramsDict = @{@"userName": _txtFieldUsername.text, @"password": _txtFieldPassword.text, @"deviceOS":@"iOS"};
        
        [self showProgressHudWithMessage:@"SigningIn"];
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:departmentLogin withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            if (responseType == eResponseTypeSuccessJSON)
            {
                NSDictionary *dictUserdata = [response objectForKey:@"responseObject"];
                
                [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"ssoId"] forKey:@"ssoId"];

                [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"staffId"] forKey:@"userId"];
                [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"name"] forKey:@"name"];
                [UIViewController saveDatatoUserDefault:[dictUserdata objectForKey:@"email"] forKey:@"email"];
                
                if ([dictUserdata[@"mobile"] isKindOfClass:[NSString class]]) {
                    [UIViewController saveDatatoUserDefault:dictUserdata[@"mobile"] forKey:@"mobile"];
                }else{
                    [UIViewController saveDatatoUserDefault:@"" forKey:@"mobile"];
                }
                
                [UIViewController saveDatatoUserDefault:@"" forKey:@"userImageUrl"];
                [UIViewController saveDatatoUserDefault:@{@"stateId" : @"29",@"stateName" : @"Rajasthan"} forKey:@"selectedStateDict"];
                [UIViewController saveDatatoUserDefault:@{@"districtId" : @"1",@"districtName" : @"Ajmer",@"stateId" : @"29"} forKey:@"selectedDistrictDict"];
                [UIViewController saveDatatoUserDefault:nil forKey:@"selectedStateDistrictArray"];
                
                
                [UIViewController saveDatatoUserDefault:@"1" forKey:@"isUserLoggedIn"];
                [UIViewController saveDatatoUserDefault:@"department" forKey:@"loginType"];

                RootViewController *VC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
                
                [self.navigationController pushViewController:VC animated:YES];
            }
            else {
                if (responseType != eResponseTypeNoInternet)
                {
                    //[self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
//                    [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                }
            }
        }];
    }
}

/*
- (IBAction)googleSignInButtonDidTap:(id)sender {
    
    [self showProgressHudWithMessage:@"Please wait.."];
    // google Login
    [self setupGoogleLogin];
    //    [[GPPSignIn sharedInstance] authenticate];
    [[GIDSignIn sharedInstance] signIn];
}

-(void)setupGoogleLogin
{
    // *********** New google sign-in  *********** //
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.clientID = @"487854013147-unbo9frfk8tdc0kd5s41tftvdt7ratrk.apps.googleusercontent.com";
    signIn.scopes = @[ @"https://www.googleapis.com/auth/plus.login" ];
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

#pragma mark - GSignIn Delegates

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    [self hideProgressHudAfterDelay:0.0];

    if (!error) {
        
        // Perform any operations on signed in user here.
        //    NSString *userId = user.userID;                  // For client-side use only!
        //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        //    NSString *givenName = user.profile.givenName;
        //    NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        // ...
        
        RegisterViewController *vc = [RegisterViewController instantiateViewControllerWithIdentifier:@"RegisterViewController" fromStoryboard:@"Main"];
        // Pass the selected object to the new view controller.
        vc.name = fullName;
        vc.email = email;
        if (user.profile.hasImage) {
            vc.imageUrl = [user.profile imageURLWithDimension:60];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    [self hideProgressHudAfterDelay:0.0];
}
*/

@end
