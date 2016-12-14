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

//    [self setTitleLabel];
    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];

    [self showProgressHudWithMessage:@"Please wait.."];
    
    [[FFWebServiceHelper sharedManager]
                    callWebServiceWithUrl:[NSURL URLWithString:GET_JAVA_BASE_URL]
                    withParameter:nil
                    onCompletion:^(eResponseType responseType, id response)
                    {
                        [self hideProgressHudAfterDelay:0.0];
                         
                        if (responseType == eResponseTypeSuccessJSON)
                        {
                            [FFWebServiceHelper sharedManager].dynamicBaseUrl = [response objectForKey:@"server_url"];
                        }
                    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)myProfileButtonAction:(id)sender {
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

/*
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
            imageName = @"TestTask";
            text = @"Take Task";
            break;
        case 2:
            imageName = @"Payment";
            text = @"Enrollment Status";
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
    
    InstructionViewController *vc = (InstructionViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"InstructionViewController" fromStoryboard:@"Home"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/2.5, self.view.frame.size.height/4.5);
}
*/

@end
