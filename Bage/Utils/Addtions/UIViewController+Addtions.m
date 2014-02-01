//
//  UIViewController+Addtions.m
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "UIViewController+Addtions.h"

@implementation UIViewController (Addtions)

-(void) setBackBarButtonItemWithTitle:(NSString *) title{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
}

@end
