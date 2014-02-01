//
//  MatchManger.m
//  Bage
//
//  Created by Duger on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "MatchManger.h"

@interface MatchManger ()
{
    dispatch_source_t timer;
}

@end


@implementation MatchManger

@synthesize networkManager;


static MatchManger *instance = nil;
+(MatchManger *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MatchManger alloc]init];
        
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        
        networkManager = [[NetworkManager alloc]init];
        //quickMatch上传成功观察者
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quickMatchUpdateSuccess:) name:kQuickMatchingSuccess object:nil];
        //配对成功 收数据
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveTempMatchedData:) name:kDidReceiveTempMetchedData object:nil];
        //
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMatchedData:) name:kDidReceiveMetchedData object:nil];
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(timer);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDidReceiveMetchedData object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kQuickMatchingSuccess object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDidReceiveTempMetchedData object:nil];
    [networkManager release],networkManager = nil;
    [_matchedPartners release];
    [super dealloc];
}

-(void)quickMatchUpdate:(NSString *)string
{
    
    [networkManager submit:string];
}

-(void)getMatchedPartner:(NSString *)personJid
{
        NSString *require = [NSString stringWithFormat:@"personJid=%@",personJid];
    [networkManager searchMatchedList:require];
}

//定时请求 是否匹配上了
- (void)getRequiredMatchOrNot:(NSString *)personJid
{
    NSString *require = [NSString stringWithFormat:@"personJid=%@",personJid];
    //GCD定时器
    if (timer) {
        return;
    }
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), 5ull*NSEC_PER_SEC, 10ull*NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"wakeup");
        //
        [networkManager searchTempMatchedList:require];
//        dispatch_source_cancel(timer);
    });
    
//    dispatch_source_set_cancel_handler(timer, ^{
//        NSLog(@"cancel");
////        dispatch_release(timer);
//    });
    //启动
    dispatch_resume(timer);
    

}

#pragma mark - Notification Methods
-(void)quickMatchUpdateSuccess:(id)sender
{
    NSString *result = [[sender userInfo]objectForKey:@"result"];
   
        NSRange range = [result rangeOfString:@"匹配成功请刷新"];//判断字符串是否包含
        
        if (range.location == NSNotFound)//不包含
        {
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]);
            [self getRequiredMatchOrNot:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
        }
        else//包含
        {
            //直接下载数据
            [networkManager searchMatchedList:[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];
        }
}

-(void)didReceiveTempMatchedData:(id)sender
{
    if (timer) {
        dispatch_source_cancel(timer);
        dispatch_release(timer),timer = nil;
    }
    
    
    
    self.matchedPartners = [[NSArray alloc]initWithArray:[[sender userInfo]objectForKey:@"result"]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceivedTempMatchedPartners:)]) {
        [self.delegate didReceivedTempMatchedPartners:self.matchedPartners];
    }
}
-(void)didReceiveMatchedData:(id)sender
{
    self.matchedPartners = [[NSArray alloc]initWithArray:[[sender userInfo]objectForKey:@"result"]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceivedMatchedPartners:)]) {
        [self.delegate didReceivedMatchedPartners:self.matchedPartners];
    }
}


@end
