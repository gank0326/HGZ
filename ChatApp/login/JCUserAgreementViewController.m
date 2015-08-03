//
//  JCUserAgreementViewController.m
//  ChatApp
//
//  Created by joychuang on 15/3/14.
//  Copyright (c) 2015年 juchuang. All rights reserved.
//

#import "JCUserAgreementViewController.h"
#import "JCNetworkChecker.h"

@interface JCUserAgreementViewController () <UIWebViewDelegate>

@end

@implementation JCUserAgreementViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    if ([JCNetworkChecker isAvailable]) {
        NSURL *url = [NSURL URLWithString:@"http://www.joychuang.cn/privacy.html"];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight+20)];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        webView.scalesPageToFit = YES;
        webView.delegate = (id <UIWebViewDelegate> )self;
        [self.view addSubview:webView];
    }
    else {
        [JCViewHelper showError:@"网络异常"];
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf popupMyself];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [SLViewHelper addLoadingMask:self.view withTip:NSLocalizedString(@"loading", nil)];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SLViewHelper removeLoadingMask:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

@end
