//
//  UIViewController+ShowAlert.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/7/12.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UIViewController+ShowAlert.h"

@implementation UIViewController (ShowAlert)

- (void)popAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
