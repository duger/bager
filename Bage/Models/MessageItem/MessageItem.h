//
//  MessageItem.h
//  Bage
//
//  Created by lixinda on 13-12-28.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"



@interface MessageItem : NSObject

@property (nonatomic,strong) NSString * messageFromName;
@property (nonatomic,strong) NSString * messageText;
@property (nonatomic,assign) BOOL isComposing;
@property (nonatomic,strong) NSDate * receivedDate;
-(id) initWithMessage:(XMPPMessage *)message andIsComposing:(BOOL)isComposing;

@end
