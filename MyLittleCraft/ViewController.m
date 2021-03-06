//
//  ViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/4.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *> *demo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My little Craft";
    
    _demo = [self demoItems];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _demo[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = _demo[indexPath.row];
    NSString *trimmed = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *className = [trimmed stringByAppendingString:@"ViewController"];
    
    Class cls = NSClassFromString(className);
    NSAssert(cls, @"The class named %@ is not exist!", className);
    
    UIViewController *vc = [cls new];
    vc.title = name;
    [self.navigationController pushViewController:vc animated:YES];
    
    // This will call -[UIViewController viewDidLoad:] for view creation
    // So put this line of code after pushing to navigation stack is safer because the vc might use "self.navigationController" in viewDidLoad:
    vc.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Helper

- (NSArray <NSString *> *)demoItems {
    return @[ @"Below Header Refreshing",
              @"Music Search List",
              @"Swipe To Dismiss Keyboard",
              @"Multi Touch Box",
              @"Motion Camera",
              @"Web And Script" ];
}

@end
