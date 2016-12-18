//
//  ContactUsViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 10/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ActionSheetStringPicker.h"
#import "UITextField+Validation.h"

@interface ContactUsViewController () <UIAlertViewDelegate> {
    
    NSArray *arrayQueryTypes;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMessage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldQuery;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayQueryTypes = @[@"SUGGESTION",@"QUERY",@"COMPLAINT",@"FEEDBACK"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openQueryTypePicker:(id)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayQueryTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        _textFieldQuery.text = [arrayQueryTypes objectAtIndex:selectedValueIndex];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)submit:(id)sender {
    
    if (_textFieldQuery.isEmptyField || _textFieldName.isEmptyField || _textFieldEmail.isEmptyField || _textFieldMessage.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
    else if (![_textFieldEmail isEmailValid]) {
        [self showAlert:@"Please enter a valid email Id!"];
    }
    else
    {
        NSDictionary *paramsDict = @{@"type": _textFieldQuery.text, @"name": _textFieldName.text, @"message": _textFieldMessage.text, @"email" : _textFieldEmail.text, CHECKSOURCE_KEY : CHECKSOURCE_VALUE};
        
        [self showProgressHudWithMessage:@"Please wait.."];
        
        [[FFWebServiceHelper sharedManager]
                 callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:GET_USER_ALERTS]
                 withParameter:paramsDict
                 onCompletion:^(eResponseType responseType, id response)
                 {
                     [self hideProgressHudAfterDelay:0.1];

                     if (responseType == eResponseTypeSuccessJSON)
                     {
                         [self showDelegatedAlertwithTitle:nil message:@"Your request has been submitted." tag:1];
                     }
                     else{
                         [self showAlert:@"Something went wrong, Please try after sometime."];
                     }
                 }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self popVCAction:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
