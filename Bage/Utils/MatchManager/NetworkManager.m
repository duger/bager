//
//  NetworkManager.m
//  Bage
//
//  Created by Duger on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "NetworkManager.h"
//状态栏第三方类
#import "JDStatusBarNotification.h"
#import "JSONKit.h"


#define kQuickMatch @"http://124.205.147.26/student/com_lanou3G_class10_Bage/QuickMatch.php"
#define kTempMatched @"http://124.205.147.26/student/com_lanou3G_class10_Bage/TempMatched.php"
#define kMatched @"http://124.205.147.26/student/com_lanou3G_class10_Bage/Matched.php"
#define kQuickMatchingSuccess @"QuickMatchingSuccess"


@implementation NetworkManager
{
    NSMutableData *mutalbeData;
    //声明私有变量，用来记录网络文件大小
    NSNumber *fileWeight;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//快速匹配的上传请求
-(void)submit:(NSString *)string
{
    //异步请求方式3
    NSString *postStr = string;
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建复杂请求对象
    NSURL *url = [NSURL URLWithString:kQuickMatch];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
     //设置复杂请求的属性，简单请求不能设置
     //默认GET
     [mutableRequest setHTTPMethod:@"POST"];  //post put
     //设置http协议发送的数据头（header）
     //学名HeaderFields
     //例 2 Accept—Language：en-US
//     [mutableRequest setValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
//    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:mutableRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!connectionError && responseCode == 200) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                //推送成功通知
                [[NSNotificationCenter defaultCenter]postNotificationName:kQuickMatchingSuccess object:self userInfo:[NSDictionary dictionaryWithObject:str forKey:@"result"]];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"配对" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                
                //[alertView performSelector:@selector(show) withObject:nil afterDelay:2];
                
                [JDStatusBarNotification showWithStatus:@"服务器接收到数据！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
            });
            NSLog(@"数据数据%@",str);
        }
        
    }];


}

//搜索是否匹配成功
-(void)searchTempMatchedList:(NSString *)submin
{
    //异步请求方式3
    NSString *postStr = submin;
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建复杂请求对象
    NSURL *url = [NSURL URLWithString:kTempMatched];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    //设置复杂请求的属性，简单请求不能设置

    [mutableRequest setHTTPMethod:@"POST"];  //post put

    [mutableRequest setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:mutableRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"%d",responseCode);
        NSError *error;
        if (!connectionError && responseCode== 200) {
            NSString *tempStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",tempStr);
            
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (result) {
                
                if (result.count > 0) {
                    [JDStatusBarNotification showWithStatus:@"配对成功！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
                    
                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kDidReceiveTempMetchedData object:nil userInfo:@{@"result": result}];

                }else{
                    NSLog(@"继续匹配");
                }
                
            }

        }
     
    }];

    
}

//下载匹配好得数据
-(void)searchMatchedList:(NSString *)submin
{
    //异步请求方式3
    NSString *postStr = submin;
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //创建复杂请求对象
    NSURL *url = [NSURL URLWithString:kMatched];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    //设置复杂请求的属性，简单请求不能设置
    
    [mutableRequest setHTTPMethod:@"POST"];  //post put
    
    [mutableRequest setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:mutableRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        NSLog(@"%d",responseCode);
        NSError *error;
        if (!connectionError && responseCode== 200) {
            NSString *tempStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",tempStr);
            
            NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (result) {
                
                if (result.count > 0) {
                    [JDStatusBarNotification showWithStatus:@"取数据成功！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
                    
                    //发送通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:kDidReceiveMetchedData object:nil userInfo:@{@"result": result}];
                    
                }
                
            }
            
        }
        
    }];
    
    
}


@end
