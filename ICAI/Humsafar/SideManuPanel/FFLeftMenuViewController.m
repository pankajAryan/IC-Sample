//
//  FFLeftMenuViewController.m
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FFLeftMenuViewController.h"

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "NotificationViewController.h"
#import "EnrollmentStatusViewController.h"
#import "InstructionViewController.h"
#import "ApplicationFormViewController.h"
#import "CommonWebViewController.h"
#import "RegisterViewController.h"
#import "SecurityUtil.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
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
            RegisterViewController *vc = [RegisterViewController instantiateViewControllerWithIdentifier:@"RegisterViewController" fromStoryboard:@"Main"];
            vc.applicationID = [UIViewController retrieveDataFromUserDefault:@"application_id"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            EnrollmentStatusViewController *vc = (EnrollmentStatusViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"EnrollmentStatusViewController" fromStoryboard:@"Home"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 2:
        {
            InstructionViewController *vc = (InstructionViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"InstructionViewController" fromStoryboard:@"Home"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
            {
                NSString *applicationId = [UIViewController retrieveDataFromUserDefault:@"application_id"];
                NSString *urlString = [UIViewController retrieveDataFromUserDefault:@"application_download"];
                
                if (!urlString) {
                    urlString = [NSString stringWithFormat:@"%@%@",Application_Form_Download,[SecurityUtil encryptMD5String:applicationId]];
                }
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            }
            
            break;

        case 4:
        {
            NotificationViewController *vc = (NotificationViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"NotificationViewController" fromStoryboard:@"Home"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5:
        {
            CommonWebViewController *controller = (CommonWebViewController*)[UIViewController instantiateViewControllerWithIdentifier:@"CommonWebViewController" fromStoryboard:@"Other"];
            controller.screenTitle = @"About ICAI";
            controller.urlString = ABOUT_ICAI;
            [homeController.navigationController pushViewController:controller animated:YES];
        }
            break;

        case 6:
        {
            CommonWebViewController *controller = (CommonWebViewController*)[UIViewController instantiateViewControllerWithIdentifier:@"CommonWebViewController" fromStoryboard:@"Other"];
            controller.screenTitle = @"About Commerce Wizard";
            controller.urlString = About_Commerce_Wizard;
            [homeController.navigationController pushViewController:controller animated:YES];
        }
            break;
        
        case 7:
        {
            CommonWebViewController *controller = (CommonWebViewController*)[UIViewController instantiateViewControllerWithIdentifier:@"CommonWebViewController" fromStoryboard:@"Other"];
            controller.screenTitle = @"About CCC, ICAI";
            controller.urlString = About_CCC;
            [homeController.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 8:
        {
            CommonWebViewController *controller = (CommonWebViewController*)[UIViewController instantiateViewControllerWithIdentifier:@"CommonWebViewController" fromStoryboard:@"Other"];
            controller.screenTitle = @"FAQ";
            controller.urlString = FAQ;
            [homeController.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 9:
        {
            [App_Delegate logout];
        }
            break;
            
        default:
            break;
    }

    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
            return [UIImage imageNamed:@"Payment_left"];
            break;
            
        case 2:
            return [UIImage imageNamed:@"TakeTest"];
            break;

        case 3:
            return [UIImage imageNamed:@"ApplicationForm_left"];
            break;

        case 4:
            return [UIImage imageNamed:@"Notification"];
            break;
          
        case 5:
            return [UIImage imageNamed:@"MyProfile"];//Todo, change
            break;
            
        case 6:
            return [UIImage imageNamed:@"AboutExam"];
            break;
            
        case 7:
            return [UIImage imageNamed:@"AboutExam"];
            break;
            
        case 8:
            return [UIImage imageNamed:@"About"];
            break;
        
        case 9:
            return [UIImage imageNamed:@"Logout"];
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
            return @"Enrollment Status";
            break;
            
        case 2:
            return @"Take Test";
            break;

        case 3:
            return @"Application Form";
            break;

        case 4:
            return @"Notification";
            break;
            
        case 5:
            return @"About ICAI";
            break;
            
        case 6:
            return @"About Commerce Wizard";
            break;
            
        case 7:
            return @"About CCC, ICAI";
            break;
            
        case 8:
            return @"FAQ";
            break;
            
        case 9:
            return @"Logout";
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
