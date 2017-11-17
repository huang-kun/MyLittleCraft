//
//  WebAndScriptViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "WebAndScriptViewController.h"
#import "WebDemoItem.h"
#import "WebViewControllerProtocol.h"

@interface WebAndScriptViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <WebDemoItem *> *demos;
@end

@implementation WebAndScriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebDemos];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WebDemoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WebDemoCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    WebDemoItem *item = self.demos[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *host = @"https://en.wikipedia.org";
    if (indexPath.row == self.demos.count - 1) {
        host = @"http://www.w3school.com.cn";
    }
    
    Class demoClass = self.demos[indexPath.row].demoClass;
    id demoObject = [demoClass new];
    if ([demoObject conformsToProtocol:@protocol(WebViewControllerProtocol)]) {
        id <WebViewControllerProtocol> webVC = demoObject;
        webVC.url = [NSURL URLWithString:host];
        [self.navigationController pushViewController:(id)webVC animated:YES];
    }
}

- (void)loadWebDemos {
    NSMutableArray *demos = [NSMutableArray array];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyJSHrefDemoViewController")
                          title:@"Get js href link"
                       subtitle:@"截获js跳转请求"]];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyJSFunctionDemoViewController")
                          title:@"Run local javascript"
                       subtitle:@"调用本地js代码"]];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyJSMessageDemoViewController")
                          title:@"Javascript injection"
                       subtitle:@"注入本地js脚本（读取标题）"]];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyJSInjectionDemoViewController")
                          title:@"Javascript injection 2"
                       subtitle:@"注入本地js脚本（修改样式）"]];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyJSInjectionTimeDemoViewController")
                          title:@"Inject HTML element"
                       subtitle:@"测试js脚本注入时机"]];
    
    [demos addObject:
     [WebDemoItem demoWithClass:NSClassFromString(@"MyDynamicScriptDemoViewController")
                          title:@"Inject HTML element 2"
                       subtitle:@"注入远程的js脚本"]];
    
    self.demos = demos.copy;
}

@end
