//
//  HttpDownload.h
//  DBuyer
//
//  Created by liuxiaodan on 13-10-14.
//  Copyright (c) 2013年 liuxiaodan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@interface HttpDownload : NSObject<NSURLConnectionDataDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>{
//    NSMutableData *resultData;
//    id<NetServiceDelegate>delegate;
//    NSURLConnection *thisConnection;

    NSURLConnection *httpConnection;
    NSMutableData *downloadData;
    
}
@property(readonly,nonatomic)NSMutableData *downloadData;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)SEL method;
@property(nonatomic,assign)SEL failMethod;
@property(nonatomic,assign)NSInteger type;
//@property(assign,nonatomic)id<NetServiceDelegate>delegate;
//@property(retain,nonatomic)NSURLConnection *thisConnection;
//@property(retain,nonatomic)NSMutableData *resultData;

-(void)downloadFromUrl:(NSString *)url;
-(void)getResultData:(NSMutableDictionary *)params baseUrl:(NSString *)baseUrl;
#pragma mark - 第三方
-(void)downloadFromUrlWithASI:(NSString *)url;
-(void)downloadFromUrlWithASI:(NSString *)url dict:(NSMutableDictionary *)dict;
- (void)ConnectionCanceled;


@end
