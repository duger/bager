//
//  BagePersonChatViewController.h
//  Bage
//
//  Created by lixinda on 14-1-6.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "XMPPManager.h"

@interface BagePersonChatViewController : JSMessagesViewController<JSMessagesViewDataSource, JSMessagesViewDelegate,XMPPManagerMessageDelegate>


@property (strong, nonatomic) NSMutableArray *timestamps;

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;

//消息列表
@property (strong, nonatomic) NSFetchedResultsController *fetchedMessageResultsController;
@end
