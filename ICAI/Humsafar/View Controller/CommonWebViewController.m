//
//  CommonWebViewController.m
//  ICAI
//
//  Created by Pankaj Yadav on 04/12/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "CommonWebViewController.h"

@interface CommonWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lbl_title.text = self.title;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - btn action
- (IBAction)popVCAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegates
-(void)showLoading:(BOOL)isShow{
    if (isShow)
        [self showProgressHudWithMessage:nil];
    else
        [self hideProgressHudAfterDelay:0.0];
}

#pragma mark - UIWeb view delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoading:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self showLoading:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showLoading:NO];
}

@end
