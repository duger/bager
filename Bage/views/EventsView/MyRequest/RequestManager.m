//
//  RequestManager.m
//  Neighbours
//
//  Created by 王帅帅 on 13-12-24.
//  Copyright (c) 2013年 王帅帅. All rights reserved.
//

#import "RequestManager.h"

@interface RequestManager ()
{
    NSMutableData *receivedData;//用来存储接受到得数据

}
/**
 *用来组装同步请求的网络请求的字符串
 **/
- (NSString *)_createSynchronousParamString;
/**
 *用来组装异步请求的网络请求的字符串
 **/
- (NSString *)_createAsynchronousParamString;
/**
 *用来清空存储数据的数组
 **/
- (void)_cleanCatchedData;
@end

@implementation RequestManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc
{
    [_requestConnection release];
    [_requestTag release];
    [receivedData release];
    [requestSting release];
    [super dealloc];
}
#pragma mark - Private Methods

/**
 *用来组装同步请求的网络请求的字符串
 **/
- (NSString *)_createSynchronousParamString
{
    NSMutableString *stringTemp = [NSMutableString stringWithString:requestSting];
    [stringTemp appendString:@"?"];
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in [paramsDictionary allKeys]) {
        NSString *tempString = [NSString stringWithFormat:@"%@=%@",key,[paramsDictionary objectForKey:key]];
        [paramArray addObject:tempString];
    }
    [stringTemp appendString:[paramArray componentsJoinedByString:@"&"]];
    return stringTemp;
}
/**
 *用来组装异步请求的网络请求的字符串
 **/
- (NSString *)_createAsynchronousParamString
{
    NSMutableString *stringTemp = [NSMutableString stringWithString:requestSting];
    [stringTemp appendString:@"?"];
    NSMutableArray *paramArray = [NSMutableArray array];
    for (NSString *key in [paramsDictionary allKeys]) {
        NSString *tempString = [NSString stringWithFormat:@"%@=%@",key,[paramsDictionary objectForKey:key]];
        [paramArray addObject:tempString];
    }
    [stringTemp appendString:[paramArray componentsJoinedByString:@"&"]];
    return stringTemp;
}
/**
 *用来清空存储数据的数组
 **/
- (void)_cleanCatchedData
{
    [receivedData setData:nil];
}
/**
 *开始同步请求的方法
 **/
- (void)startSynchronousRequestInfo
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:[self _createSynchronousParamString]];
    //将请求字符串转码，因为链接有可能有汉字
    NSString *string2 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *sourceAddressURL = [NSURL URLWithString:string2];
    
    //POST请求一定需要子类NSMutableRequest类型的对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:sourceAddressURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];//时间超时10s提示请求超时
//    [request setHTTPMethod:@"GET"];
//    NSLog(@"%@",[self _createSynchronousParamString]);
//    sourceAddressURL
//    [request setHTTPBody:[[self _createSynchronousParamString] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",request);
        self.requestConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [_requestConnection start];
}
- (void)cancelRequestConnection
{
    [_requestConnection cancel];
}
///**
// *开始异步请求的方法
// **/
//- (void)startAsynchronismRequestInfo
//{
//    NSLog(@"%@",[self _createAsynchronousParamString]);
//    //将请求字符串转码，因为链接有可能有汉字
//    NSString *string = [[self _createAsynchronousParamString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",string);
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSLog(@"%@",data);
//        if (!error) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFinishLoadingWithInfo:)]) {
//                [self.delegate request:self didFinishLoadingWithInfo:dic];
//            }
//            [self _cleanCatchedData];
//        }
//        else
//        {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailedWithError:)]) {
//                [self.delegate request:self didFailedWithError:error];
//            }
//            [self _cleanCatchedData];
//        }
//        
//    }];
//}

#pragma mark - NSConnection Data Delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receivedData) {
        receivedData = [[NSMutableData alloc] init];
    }
    [receivedData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFinishLoadingWithInfo:)]) {
        [self.delegate request:self didFinishLoadingWithInfo:dic];
    }
    [self _cleanCatchedData];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(request:didFailedWithError:)]) {
//        [self.delegate request:self didFailedWithError:error];
//    }
//    [self _cleanCatchedData];
}
@end
