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


@interface DataHolder : NSObject

@property(strong,nonatomic) NSString* placeHolderText;
@property(strong,nonatomic) NSString* displayText;
@property(assign,nonatomic) BOOL isActAsBtn;

@end

@implementation DataHolder

-(id)initWithPlaceHolder:(NSString*)placeHolder andIsActAsBtn:(BOOL)value {
    
    if (self = [super init]) {
        self.placeHolderText = placeHolder;
        self.isActAsBtn = value;
    }
    
    return self;
}
@end



@interface MyTextField : UITextField

@property(nonatomic) DataHolder *associatedModal;

@end
@implementation MyTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return NO;
}

@end




@interface RegistrationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet MyTextField *txt_value;

@end

@implementation RegistrationTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
}

@end



@interface RegisterViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL checkBoxSelected;
    NSArray *testCentersArray;
    UIDatePicker *datePicker;
    UIToolbar *toolBar;
}
@property (nonatomic) NSArray *dataHolderArray;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(dobSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    self.dataHolderArray = @[[[DataHolder alloc] initWithPlaceHolder:@"Email ID *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"First Name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Middle Name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Last Name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Gender *" andIsActAsBtn:YES],
                        [[DataHolder alloc] initWithPlaceHolder:@"Father's name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Mother's name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Date Of Birth *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Mobile number *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Address *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"City *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"District *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Zip code *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"State *" andIsActAsBtn:YES],//12
                        [[DataHolder alloc] initWithPlaceHolder:@"Country *" andIsActAsBtn:YES],
                        [[DataHolder alloc] initWithPlaceHolder:@"Class *" andIsActAsBtn:YES],
                        [[DataHolder alloc] initWithPlaceHolder:@"Board *" andIsActAsBtn:YES],
                        [[DataHolder alloc] initWithPlaceHolder:@"Board Name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"School Name *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"School Address *" andIsActAsBtn:NO],
                        [[DataHolder alloc] initWithPlaceHolder:@"Preferred Test center *" andIsActAsBtn:YES]
                        ];
    
    
    [self getTestCenterFromServer];
    
    if (self.applicationID != nil) {
        [self getProfile];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)getTestCenterFromServer {
    
    [self showProgressHudWithMessage:@"Please wait..."];
    
    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:Test_Centre_List]
     withParameter:@{CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
     onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON)
         {
             testCentersArray = [response objectForKey:kKEY_ResponseObject];
             //[self showAlert:[response objectForKey:kKEY_ErrorMessage]];
         }
         else{
             if ([response respondsToSelector:@selector(objectForKey:)]) {
                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
             }
         }
     }];
}

#pragma mark - Button Action

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkBoxBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];

    checkBoxSelected = !checkBoxSelected;
    sender.selected = !sender.selected;
}

- (IBAction)submitBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];

    if (![self validationCheck]) {
        return;
    }
    
    NSMutableArray *paramArray = [NSMutableArray new];
    
    [paramArray addObject:@"user_email"];
    [paramArray addObject:@"user_name"];
    [paramArray addObject:@"user_middlename"];
    [paramArray addObject:@"user_lastname"];
    [paramArray addObject:@"gender"];
    [paramArray addObject:@"father_name"];
    [paramArray addObject:@"mother_name"];
    [paramArray addObject:@"dob"];
    [paramArray addObject:@"mobile_number"];
    [paramArray addObject:@"street_address"];
    [paramArray addObject:@"city"];
    [paramArray addObject:@"district"];
    [paramArray addObject:@"zipcode"];
    [paramArray addObject:@"state"];
    [paramArray addObject:@"country"];
    [paramArray addObject:@"class_name"];
    [paramArray addObject:@"board_name"];
    [paramArray addObject:@"other_board"];
    [paramArray addObject:@"school_name"];
    [paramArray addObject:@"school_address"];
    [paramArray addObject:@"test_centres"];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    
    for (int i=0; i< self.dataHolderArray.count; i++) {
        DataHolder *modal = self.dataHolderArray[i];
        paraDict[paramArray[i]] = modal.displayText.length > 0 ? modal.displayText : @"";
    }
    
    paraDict[@"registration_mode"] = @"USER_ONLINE";
    
    if (self.applicationID == nil) {
        [self createAccount:paraDict];
    }else{
        [self updateProfile:paraDict];
    }
    
}

-(void)createAccount:(NSMutableDictionary*)paraDict {

    [self showProgressHudWithMessage:@"Please wait.."];

    [[FFWebServiceHelper sharedManager]
     callWebServiceWithUrl:[FFWebServiceHelper phpServerUrlWithString:Registeration]
     withParameter:paraDict
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
         else{
             if ([response respondsToSelector:@selector(objectForKey:)]) {
                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
             }
         }
     }];
}

-(void)updateProfile:(NSMutableDictionary*)paraDict {
    
    NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];

    paraDict[@"application_id"] = applicationId;
    paraDict[CHECKSOURCE_KEY] = CHECKSOURCE_VALUE;
    
    [self showProgressHudWithMessage:@"Please wait.."];

    [[FFWebServiceHelper sharedManager]
                     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:UpdateUserProfile]
                     withParameter:paraDict
                     onCompletion:^(eResponseType responseType, id response)
                     {
                         [self hideProgressHudAfterDelay:0.1];
                         
                         if (responseType == eResponseTypeSuccessJSON)
                         {
                             [self showAlert:@"Profile updated."];
                             
                             //             {
                             //                 "errorCode": 0,
                             //                 "errorMessage": "You're registered successfully. Taking you to pay the enrollment fee!",
                             //                 "responseObject": {
                             //                     "application_id": 10018619,
                             //                     "student_name": "q",
                             //                     "student_email": "rahul@yopmail.com",
                             //                     "gender": "Male",
                             //                     "application_download": "https:\/\/icaicommercewizard.com\/html2pdf\/download_pdf.php?id=39a1af6c07726bed7e6ebb59190dbe03",
                             //                     "payable_amount": 100,
                             //                     "icai_transaction_id": "10044493"
                             //                 }
                             //             }
                             
                         }
                         else{
                             if ([response respondsToSelector:@selector(objectForKey:)]) {
                                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                             }
                         }
                     }];
}

-(void)getProfile {
    
    NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];

    [self showProgressHudWithMessage:@"Please wait.."];

    [[FFWebServiceHelper sharedManager]
                     callWebServiceWithUrl:[[FFWebServiceHelper sharedManager] javaServerUrlWithString:GET_PROFILE]
                     withParameter:@{@"application_id" : applicationId, CHECKSOURCE_KEY : CHECKSOURCE_VALUE}
                     onCompletion:^(eResponseType responseType, id response)
                     {
                         [self hideProgressHudAfterDelay:0.1];
                         
                         if (responseType == eResponseTypeSuccessJSON)
                         {
                             
                         }
                         else{
                             if ([response respondsToSelector:@selector(objectForKey:)]) {
                                 [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                             }
                         }
                     }];
}

-(void)dobSelectedDate
{
    [self.view endEditing:YES];
    DataHolder *modal = self.dataHolderArray[7];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MMM-YYYY"];
    modal.displayText = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.tblView reloadData];

}
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataHolderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RegistrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegistrationTableViewCell" forIndexPath:indexPath];
    
    DataHolder *modal = self.dataHolderArray[indexPath.row];
    cell.lbl_title.text = modal.placeHolderText;
    cell.txt_value.delegate = self;
    cell.txt_value.text = modal.displayText;
    cell.txt_value.placeholder = modal.placeHolderText;
    cell.txt_value.tag = indexPath.row;
    cell.txt_value.associatedModal = modal;
    cell.txt_value.enabled = YES;
    
    if (indexPath.row == 0) {
        if (self.applicationID != nil) {
            cell.txt_value.enabled = NO;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 17) {
        DataHolder *data = self.dataHolderArray[indexPath.row-1];//16
        if (![data.displayText isEqualToString:@"Other"]) {
            return 0;
        }
    }
    
    return 85;
}

#pragma mark - UItextFiled Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    DataHolder *modal = ((MyTextField*)textField).associatedModal;
    
    if (modal.isActAsBtn) {
        
        [self.view endEditing:YES];
        NSArray *dropDownArray;
        
        switch (textField.tag) {
            case 4:// gender
                
                dropDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"genderList" ofType:@"plist"]];
                
                break;
            case 13:// state
                
                dropDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"statesList" ofType:@"plist"]];

                break;
            case 14:// country
                
                dropDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countriesList" ofType:@"plist"]];

                break;
            case 15:// class
                
                dropDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"classList" ofType:@"plist"]];

                break;
            case 16:// board
                
                dropDownArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"boardList" ofType:@"plist"]];

                break;
            case 20:// test center
                
                dropDownArray = testCentersArray;

                break;
            default:
                break;
        }
        
        [ActionSheetStringPicker showPickerWithTitle:nil rows:dropDownArray initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
            
            modal.displayText = selectedValue;
            [self.tblView reloadData];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");
        } origin:textField];

    }
    
    if (textField.tag == 7) {//DOB
        [textField setInputAccessoryView:toolBar];
        [textField setInputView:datePicker];
    }else{
        [textField setInputAccessoryView:nil];
        [textField setInputView:nil];
    }
    
    return !modal.isActAsBtn;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    DataHolder *modal = ((MyTextField*)textField).associatedModal;
    modal.displayText = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
    
    switch (textField.tag)  {
        case 8:// mobile
        {
            NSString *mobile = [NSString stringWithFormat:@"%@%@",textField.text, string];
            if (mobile.length > 10) {
                return NO;
            }else{
                NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
                return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
            }
        }
            break;
    }
    return YES;
}

#pragma mark - validation

#define kRegexEmail @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"

-(BOOL)isEmailValid:(NSString*)emailStr
{
    BOOL isValidFormat = NO;
    BOOL isValidLength = NO;
    
    isValidLength =  (emailStr.length >=6 && emailStr.length <= 50)  ? YES : NO;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegexEmail];
    isValidFormat =  [emailTest evaluateWithObject:emailStr];
    
    
    if (isValidFormat && isValidLength)
        return YES;
    else
        return NO;
}


-(BOOL)validationCheck {
    
    for (int i=0; i< self.dataHolderArray.count; i++) {
        
        DataHolder *modal = self.dataHolderArray[i];
        
        if (i == 0 ) {
            if (![self isEmailValid:modal.displayText]) {
                [self showAlert:@"Invalid Email address!"];
                return NO;
            }
        }else if (i == 17) {
            DataHolder *data = self.dataHolderArray[i-1];//16
            if ([data.displayText isEqualToString:@"Other"]) {
                if (modal.displayText.length == 0) {
                    [self showAlert:@"All input fields are mandatory!"];
                    return NO;
                }
            }
        }else{
            
            if (modal.displayText.length == 0) {
                [self showAlert:@"All input fields are mandatory!"];
                return NO;
            }
        }
    }
    
    
    if (!checkBoxSelected) {
        [self showAlert:@"Please check T&C!"];
        return NO;
    }
    
   
    
    return YES;
}

@end


