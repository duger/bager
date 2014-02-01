//
//  MatchManger.h
//  Bage
//
//  Created by Duger on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "NSString+Addtions.h"

@protocol MatchMangerDelegate <NSObject>

@optional
//收到配对的Partner回调方法
-(void)didReceivedTempMatchedPartners:(NSArray *)partners;

-(void)didReceivedMatchedPartners:(NSArray *)partners;
@end

@interface MatchManger : NSObject
{
    NetworkManager *networkManager;
}

@property (nonatomic, assign) id<MatchMangerDelegate>delegate;

@property (nonatomic,retain) NetworkManager *networkManager;

//已经匹配的partner
@property (nonatomic,retain) NSArray *matchedPartners;

+(MatchManger *)defaultManager;

//快速匹配
-(void)quickMatchUpdate:(NSString *)string;

//定时请求 是否匹配上了
- (void)getRequiredMatchOrNot:(NSString *)personJid;

//
-(void)getMatchedPartner:(NSString *)personJid;

@end
