//
//  RegisterViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "RegisterViewController.h"
#import "ActionSheetStringPicker.h"
#import "UITextField+Validation.h"
#import "UIViewController+Utility.h"
#import "OTPViewController.h"
#import "RootViewController.h"

@interface RegisterViewController () <UITextFieldDelegate> {
    
    NSDictionary *selectedStateInfo;
    NSDictionary *selectedDistrictInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldState;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldDist;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _txtFieldName.text = self.name;
    _txtFieldEmail.text = self.email;
    _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_imageUrl]];

    self.imageView.layer.cornerRadius = 28;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.imageView.layer.borderWidth = 3;
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetStates withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            arrayStatesData = [response objectForKey:kKEY_ResponseObject];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
           // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
    
    if (textField == _txtFieldMobile) {
        NSString *mobile = [NSString stringWithFormat:@"%@%@",textField.text, string];
        if (mobile.length > 10) {
            return NO;
        }else{
            NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Button Actions
- (IBAction)btnBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnSubmitAction:(UIButton *)sender {
//    [UIViewController saveDatatoUserDefault:@"11" forKey:@"userId"];
//    [UIViewController saveDatatoUserDefault:@"1" forKey:@"isUserLoggedIn"];
    
    RootViewController *VC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)showStatePicker:(id)sender {
   
    [_txtFieldName resignFirstResponder];
    [_txtFieldMobile resignFirstResponder];
    [_txtFieldEmail resignFirstResponder];
    [_txtFieldState resignFirstResponder];
    [_txtFieldDist resignFirstResponder];
    
    NSMutableArray *stateTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayStatesData.count; i++) {
        
        NSDictionary *dict = [arrayStatesData objectAtIndex:i];
        [stateTitles addObject:[dict objectForKey:@"stateName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[stateTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < arrayStatesData.count ) {
            
            selectedStateInfo = [arrayStatesData objectAtIndex:selectedValueIndex];
            _txtFieldState.text = selectedValue;
            _txtFieldDist.text = @"";
        }
        
         [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId":selectedStateInfo[@"stateId"]} onCompletion:^(eResponseType responseType, id response) {
         
             if (responseType == eResponseTypeSuccessJSON) {
                 arrayDistrictsData = [response objectForKey:kKEY_ResponseObject];
             }
             else{
                 [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                 // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
             }
         }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
    
}

- (IBAction)showDistrictPicker:(id)sender {
    
    [_txtFieldName resignFirstResponder];
    [_txtFieldMobile resignFirstResponder];
    [_txtFieldEmail resignFirstResponder];
    [_txtFieldState resignFirstResponder];
    [_txtFieldDist resignFirstResponder];
    
    NSMutableArray *DistTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayDistrictsData.count; i++) {
        
        NSDictionary *dict = [arrayDistrictsData objectAtIndex:i];
        [DistTitles addObject:[dict objectForKey:@"districtName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[DistTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < arrayDistrictsData.count ) {

            selectedDistrictInfo = [arrayDistrictsData objectAtIndex:selectedValueIndex];
            _txtFieldDist.text = selectedValue;
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)registerButtonDidTap:(id)sender {
    
    if (_txtFieldName.isEmptyField || _txtFieldMobile.isEmptyField || _txtFieldEmail.isEmptyField || _txtFieldState.isEmptyField || _txtFieldDist.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
    else if (!_txtFieldMobile.isMobileNumberValid) {
        [self showAlert:@"Mobile must contain 10 characters!"];
    }
    else if (!_txtFieldEmail.isEmailValid) {
        [self showAlert:@"Invalid Email address!"];
    }
    else {

        NSDictionary *paramsDict = @{@"userName": _txtFieldName.text, @"emailId": _txtFieldEmail.text, @"profileImageURL": _imageUrl.absoluteString, @"mobileNumber": _txtFieldMobile.text, @"stateId": selectedStateInfo[@"stateId"], @"defaultDistrictId": selectedDistrictInfo[@"districtId"], @"deviceOS":@"iOS"};
        
            [self showProgressHudWithMessage:@"Registering user"];
            
            [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:RegisterUser withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
                
                [self hideProgressHudAfterDelay:0.1];
                
                if (responseType == eResponseTypeSuccessJSON)
                {
                    [UIViewController saveDatatoUserDefault:[response objectForKey:@"responseObject"] forKey:@"userId"];
                    [UIViewController saveDatatoUserDefault:_txtFieldName.text forKey:@"name"];
                    [UIViewController saveDatatoUserDefault:_txtFieldEmail.text forKey:@"email"];
                    [UIViewController saveDatatoUserDefault:_txtFieldMobile.text forKey:@"mobile"];
                    [UIViewController saveDatatoUserDefault:_imageUrl.absoluteString forKey:@"userImageUrl"];
                    [UIViewController saveDatatoUserDefault:selectedStateInfo forKey:@"selectedStateDict"];
                    [UIViewController saveDatatoUserDefault:selectedDistrictInfo forKey:@"selectedDistrictDict"];
                    [UIViewController saveDatatoUserDefault:arrayDistrictsData forKey:@"selectedStateDistrictArray"];

                    [UIViewController saveDatatoUserDefault:@"1" forKey:@"isUserLoggedIn"];
                    [UIViewController saveDatatoUserDefault:@"user" forKey:@"loginType"];


                    // Present OTP VC
                    OTPViewController *VC = [OTPViewController instantiateViewControllerWithIdentifier:@"OTPViewController" fromStoryboard:@"Main"];
                    VC.mobileNumber = _txtFieldMobile.text;
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


