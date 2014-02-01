//
//  MessageItem.m
//  Bage
//
//  Created by lixinda on 13-12-28.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "MessageItem.h"
#import "XMPPMessage.h"


@implementation MessageItem


-(id) initWithMessage:(XMPPMessage *)message andIsComposing:(BOOL)isComposing{
    self = [self init];
    if (self) {
        self.messageText = message.body;
        self.isComposing = isComposing;
        self.receivedDate = [NSDate date];        
        self.messageFromName = [[ToolsClass instance]cutString:message.from.bareJID.description OfSubStr:kXMPPHostName];
    }
    return self;
}

@end
