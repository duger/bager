//
//  HttpDownload.m
//  DBuyer
//
//  Created by liuxiaodan on 13-10-14.
//  Copyright (c) 2013年 liuxiaodan. All rights reserved.
//

#import "HttpDownload.h"

@implementation HttpDownload
@synthesize downloadData,method,type,delegate;
-(id)init{
    if(self=[super init]){
        downloadData=[[NSMutableData alloc]init];
    }
    return self;
}
-(void)dealloc{
//    [super dealloc];
}
/*
//get 加参数
-(NSString *)appendParamsFor:(NSString *)url{
    
    int flag = 0;
    for (int i = 0; i<url.length; i++) {
        
        char *c = (char *)[url characterAtIndex:i];
        if (c == '?') {
            
            flag = 1;
        }
    }
//    所有接口添加stamp，verify，versionNum ，os_code,size_code参数（时间戳 ，验证码，版本号，平台ID,像素尺寸）
    NSString *stamp = [TimeStamp timeStamp];
    NSString *verify = [MD5 md5];
    
//    versionNum
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:@"versionNum"];
    NSString *os_code = @"2";
    NSString *size_code = [NSString stringWithFormat:@"%d",[UIDevice currentResolution]];
    
    NSString *newUrl = nil;
    if (flag == 1) {
        
        newUrl = [url stringByAppendingString:[NSString stringWithFormat:@"&stamp=%@&verify=%@&versionNum=%@&os_code=%@&size_code=%@",stamp,verify,version,os_code,size_code]];
    }else{
        
        newUrl = [url stringByAppendingString:[NSString stringWithFormat:@"?stamp=%@&verify=%@&versionNum=%@&os_code=%@&size_code=%@",stamp,verify,version,os_code,size_code]];
    }
    NSLog(@"%@",newUrl);
    return newUrl;
}
*/
-(void)downloadFromUrl:(NSString *)url{

//    url = [self appendParamsFor:url];
    url = @"http://124.205.147.26/student/com_lanou3G_class10_Bage/Contact/search/searchPersonList.php?username=wang";
    if(httpConnection){
        [httpConnection release];
        httpConnection=nil;
    }
    NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp)]];
    NSURLRequest *request=[NSURLRequest requestWithURL:newUrl];
    httpConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}
-(void)getResultData:(NSMutableDictionary *)params baseUrl:(NSString *)baseUrl{
    
 //   [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    NSString *postUrl=[self createPostURL:params];
    NSLog(@"post请求的网址是 %@",postUrl);
    NSMutableURLRequest *theRequst=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:baseUrl] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0];
    [theRequst setHTTPMethod:@"POST"];
    [theRequst setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequst setHTTPBody:[postUrl dataUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp)]];
    NSLog(@"Request %@",theRequst);
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:theRequst delegate:self];
    httpConnection = con;
    [theRequst release];
    [con autorelease];
}

- (void)ConnectionCanceled
{
    if (httpConnection)
    {
        [httpConnection cancel];
        downloadData = nil;
        httpConnection = nil;
    }
}

#pragma mark - 第三方
-(void)downloadFromUrlWithASI:(NSString *)url{
    NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:newUrl];
       request.delegate=self;
    [request startAsynchronous];//启动异步下载;
}
-(void)downloadFromUrlWithASI:(NSString *)url dict:(NSMutableDictionary *)dict{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate=self;
    NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp);
    [request setStringEncoding:enc ];
    for(NSString * key  in [dict allKeys]){
        
        id object=[dict objectForKey:key];
        [request setPostValue:object forKey:key];
    }
    [request startSynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    [downloadData setLength:0];
    [downloadData appendData:request.rawResponseData];
    if([self.delegate respondsToSelector:self.method]){
        [self.delegate performSelector:self.method withObject:self];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@"第三方请求失败");
    if([self.delegate respondsToSelector:self.failMethod]){
        [self.delegate performSelector:self.failMethod withObject:self];
    }
}

#pragma mark - NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if([response isKindOfClass:[NSHTTPURLResponse class]]){
        NSHTTPURLResponse *newResponse=(NSHTTPURLResponse *)response;
        NSLog(@"states_code:%d",[newResponse statusCode]);
    }
    [downloadData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [downloadData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    if([self.delegate respondsToSelector:self.method]){
        [self.delegate performSelector:self.method withObject:self];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
   
    NSLog(@"请求失败！");
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    if([error code]==kCFURLErrorNotConnectedToInternet){
        NSDictionary *userInfo=[NSDictionary dictionaryWithObject:@"请检查网址" forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError=[NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleError:noConnectionError];
    }
    else{
        [self handleError:error];
    }
   
}
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    if([self.delegate respondsToSelector:self.failMethod]){
        
        [self.delegate performSelector:self.failMethod withObject:self];
    }

}
-(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}
@end
