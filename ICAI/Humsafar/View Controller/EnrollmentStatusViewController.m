//
//  EnrollmentStatusViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 11/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "EnrollmentStatusViewController.h"

@interface EnrollmentStatusViewController ()

@end

@implementation EnrollmentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
