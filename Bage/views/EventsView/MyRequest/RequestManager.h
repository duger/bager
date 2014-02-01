//
//  RequestManager.h
//  Neighbours
//
//  Created by 王帅帅 on 13-12-24.
//  Copyright (c) 2013年 王帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RequestManager;
/**
 *接收到数据成功或者失败的方法
 **/
@protocol NBRequestDataDelegate <NSObject>
/**
 *请求完后调用的方法
 **/
- (void)request:(RequestManager *)request didFinishLoadingWithInfo:(id)info;
/**
 *失败后调用的方法
 **/
- (void)request:(RequestManager *)request didFailedWithError:(NSError *)error;

@end


@interface RequestManager : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableDictionary *paramsDictionary;//网络请求的参数字典
    NSString *requestSting;//网络请求的地址
}
@property (nonatomic,assign) id<NBRequestDataDelegate>delegate;//assign放置互相引用

@property (nonatomic,retain) NSString *requestTag;
@property (nonatomic,retain) NSURLConnection *requestConnection;
/**
 *开始同步请求的方法
 **/
- (void)startSynchronousRequestInfo;
///**
// *开始异步请求的方法
// **/
//- (void)startAsynchronismRequestInfo;
- (void)cancelRequestConnection;

@end
