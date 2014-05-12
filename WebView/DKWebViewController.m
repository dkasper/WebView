//
//  DKWebViewController.m
//  WebView
//
//  Created by David Kasper on 5/11/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import "DKWebViewController.h"
#import "DKSettingsViewController.h"

@interface DKWebViewController ()<UISearchBarDelegate, UIWebViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIPopoverController *settingsPopover;

@end

@implementation DKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.bounds = CGRectMake(0, 0, 20, 20);
    [customButton addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"Gear"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    // this is causing an issue with a black bar appearing in the webview
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = [[NSUserDefaults standardUserDefaults] boolForKey:ScaleKey];
    self.webView.suppressesIncrementalRendering = [[NSUserDefaults standardUserDefaults] boolForKey:SupressKey];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSettings];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    NSString *urlString = searchBar.text;
    if (![searchBar.text hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [searchBar resignFirstResponder];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)settings:(id)sender {
    DKSettingsViewController *settingsController = [[DKSettingsViewController alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.settingsPopover = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        self.settingsPopover.delegate = self;
        [self.settingsPopover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self.navigationController pushViewController:settingsController animated:YES];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0));
    }];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self updateSettings];
}

- (void)updateSettings {
    BOOL shouldReload = NO;
    
    BOOL scaleToFit = [[NSUserDefaults standardUserDefaults] boolForKey:ScaleKey];
    if (scaleToFit != self.webView.scalesPageToFit) {
        self.webView.scalesPageToFit = scaleToFit;
        shouldReload = YES;
    }
    
    BOOL suppressRendering = [[NSUserDefaults standardUserDefaults] boolForKey:SupressKey];
    if (suppressRendering != self.webView.suppressesIncrementalRendering) {
        self.webView.suppressesIncrementalRendering = suppressRendering;
        shouldReload = YES;
    }
    
    if (shouldReload) {
        [self.webView reload];
    }
}

@end
