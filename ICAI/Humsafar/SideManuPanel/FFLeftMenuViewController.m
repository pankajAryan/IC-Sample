//
//  FFLeftMenuViewController.m
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FFLeftMenuViewController.h"

#import "HomeViewController.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
//#import "MyFeedsVC.h"
//#import "MyIncentiveVC.h"
//#import "MyVehicleProfileVC.h"
//#import "FaqViewController.h"
#import "ProfileViewController.h"
#import "NotificationViewController.h"
#import "PaymentViewController.h"
#import "InstructionViewController.h"
#import "ApplicationFormViewController.h"
#import "AboutViewController.h"
#import "AboutExamViewController.h"
#import "AnalysisViewController.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


static NSString *stringLeftMenuCellIdentifier  = @"LeftMenuCell";

@interface FFLeftMenuViewController ()

@end

@implementation FFLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.imgVw_userImg.layer.cornerRadius = 28;
//    self.imgVw_userImg.layer.masksToBounds = YES;
//    self.imgVw_userImg.layer.borderColor = [UIColor orangeColor].CGColor;
//    self.imgVw_userImg.layer.borderWidth = 3;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.lbl_name.text = [UIViewController retrieveDataFromUserDefault:@"name"];
//    [self.imgVw_userImg setImageWithURL:[NSURL URLWithString:[UIViewController retrieveDataFromUserDefault:@"userImageUrl"]] placeholderImage:nil];
}

#pragma mark- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    HomeViewController *homeController = (HomeViewController*)self.sideMenuViewController.contentViewController;

    switch (index)
    {
        case 0:
        {
//
//            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
//                
//                ProfileViewController2 *vc = (ProfileViewController2 *)[UIViewController instantiateViewControllerWithIdentifier:@"ProfileViewController2" fromStoryboard:@"LeftMenuScenes"];
//                [homeController.navigationController pushViewController:vc animated:YES];
//            }else{ // G+ login
//                
                ProfileViewController *vc = (ProfileViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"ProfileViewController" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            NotificationViewController *vc = (NotificationViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"NotificationViewController" fromStoryboard:@"Home"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 2:
        {
//            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
//                MyFeedsVC *vc = (MyFeedsVC *)[UIViewController instantiateViewControllerWithIdentifier:@"MyFeedsVC" fromStoryboard:@"LeftMenuScenes"];
//                [homeController.navigationController pushViewController:vc animated:YES];
//            }else{ // G+ login
                PaymentViewController *vc = (PaymentViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"PaymentViewController" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case 3:
            {
                InstructionViewController *vc = (InstructionViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"InstructionViewController" fromStoryboard:@"Home"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }
            
            break;

        case 4:
        {
            ApplicationFormViewController *vc = (ApplicationFormViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"ApplicationFormViewController" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5:
        {
            AboutViewController *vc = (AboutViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"AboutViewController" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 6:
        {
            AboutExamViewController *vc = (AboutExamViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"AboutExamViewController" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        case 7:
//            [App_Delegate logout];
            break;
            
        case 8:
        {
            AnalysisViewController *controller = (AnalysisViewController*)[UIViewController instantiateViewControllerWithIdentifier:@"AnalysisViewController" fromStoryboard:@"LeftMenuScenes"];            
            [homeController.navigationController pushViewController:controller animated:YES];
        }
            break;
            
//        case 9:
//        {
//            AboutViewController *vc = [AboutViewController new];
//            [homeController.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//  
//        case 10:
//            [App_Delegate logout];
//            break;
            
        default:
            break;
    }

    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringLeftMenuCellIdentifier];
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:21];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:22];

    icon.image = [self imageIconForMenuItemAtIndex:indexPath.row];
    titleLabel.text = [self titleForMenuItemAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark- Private Methods

- (UIImage*)imageIconForMenuItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            return [UIImage imageNamed:@"MyProfile"];
            break;
            
        case 1:
            return [UIImage imageNamed:@"Notification"];
            break;
            
        case 2:
            return [UIImage imageNamed:@"Payment_left"];
            break;

        case 3:
            return [UIImage imageNamed:@"TakeTest"];
            break;

        case 4:
            return [UIImage imageNamed:@"ApplicationForm_left"];
            break;
          
        case 5:
            return [UIImage imageNamed:@"About"];
            break;
            
        case 6:
            return [UIImage imageNamed:@"AboutExam"];
            break;
            
        case 7:
            return [UIImage imageNamed:@"Logout"];
            break;
            
        case 8:
            return [UIImage imageNamed:@"Analysis"];
            break;

        default: return nil;
            
            break;
    }
}

- (NSString*)titleForMenuItemAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"My Profile";
            break;
            
        case 1:
            return @"Notification";
            break;
            
        case 2:
            return @"Payment";
            break;

        case 3:
            return @"Take Test";
            break;

        case 4:
            return @"Application Form";
            break;
            
        case 5:
            return @"About";
            break;
            
        case 6:
            return @"About Exam";
            break;
            
        case 7:
            return @"Logout";
            break;
            
        case 8:
            return @"Analysis";
            break;
            
        default:
            return nil;
            
            break;
    }
}

/*

-(void) openCatalogueControllerWithData:(NSString*)dataModelURL{
    @try {
        HomeViewController *homeController = (HomeViewController*)[((UINavigationController*)self.sideMenuViewController.contentViewController) topViewController];
        [homeController pushToParticulerClass:@"catalog" withurl:dataModelURL header:nil];
    }
    @catch (NSException *exception) {
        
    }
}

*/




@end
