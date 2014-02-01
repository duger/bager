//
//  UIImageView+GCD.m
//  DBuyer
//
//  Created by liuxiaodan on 13-10-15.
//  Copyright (c) 2013年 liuxiaodan. All rights reserved.
//

#import "UIImageView+GCD.h"

@implementation UIImageView (GCD)
-(void)setImageWithUrl:(NSString *)url complete:(DownloadFinish)df{
    
    NSString * newUrl=[url copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSData * data=[NSData dataWithContentsOfURL:[NSURL URLWithString:newUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            df(newUrl);
            self.image=[UIImage imageWithData:data];
        });
    });
    [newUrl release];
}
@end
