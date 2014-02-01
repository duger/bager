//
//  UIImageView+GCD.h
//  DBuyer
//
//  Created by liuxiaodan on 13-10-15.
//  Copyright (c) 2013年 liuxiaodan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DownloadFinish)(NSString * message);
@interface UIImageView (GCD)
-(void)setImageWithUrl:(NSString *)url complete:(DownloadFinish)df;
@end
