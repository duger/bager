//
//  BagePersonChatViewController.h
//  Bage
//
//  Created by lixinda on 14-1-6.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "XMPPManager.h"

@interface BagePersonChatViewController : JSMessagesViewController<JSMessagesViewDataSource, JSMessagesViewDelegate,XMPPManagerDelegate>
@property (nonatomic,strong) NSMutableArray * messageItemArray;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSMutableArray *subtitles;
@property (strong, nonatomic) NSDictionary *avatars;

@end
