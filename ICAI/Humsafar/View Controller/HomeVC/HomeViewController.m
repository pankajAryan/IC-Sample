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
#import "InstructionViewController.h"

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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)myProfileButtonAction:(id)sender {
}

- (IBAction)takeTestAction:(id)sender {
    [self showAlert:@"Coming soon..."];
}

- (IBAction)enrollmentPaymentStatusAction:(id)sender {
}

- (IBAction)applicationFormDidTap:(id)sender {
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
