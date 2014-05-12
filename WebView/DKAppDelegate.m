//
//  DKAppDelegate.m
//  WebView
//
//  Created by David Kasper on 5/11/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import "DKAppDelegate.h"
#import "DKWebViewController.h"

@implementation DKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DKWebViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
