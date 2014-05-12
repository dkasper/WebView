//
//  DKSettingsViewController.m
//  WebView
//
//  Created by David Kasper on 5/11/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import "DKSettingsViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface DKSettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DKSettingsViewController

static NSString *cellID = @"SettingsCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"Settings";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"Clear Cached Data";
        
        // System Blue
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"Scale Pages To Fit";
        cell.textLabel.textColor = [UIColor blackColor];
        UISwitch *scaleSwitch = [[UISwitch alloc] init];
        scaleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:ScaleKey];
        [scaleSwitch addTarget:self action:@selector(scaleChanged:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = scaleSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textLabel.text = @"Suppress Incremental Rendering";
        cell.textLabel.textColor = [UIColor blackColor];
        UISwitch *scaleSwitch = [[UISwitch alloc] init];
        scaleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:SupressKey];
        [scaleSwitch addTarget:self action:@selector(supressChanged:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = scaleSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [SVProgressHUD showSuccessWithStatus:@"Cleared Cache"];
    }
}

- (void)scaleChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:ScaleKey];
}

- (void)supressChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:SupressKey];
}

@end
