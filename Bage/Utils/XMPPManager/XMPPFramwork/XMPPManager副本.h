//
//  XMPPManager.h
//  Bage
//
//  Created by lixinda on 13-12-27.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "BuddyItem.h"
#import "MessageItem.h"


@class XMPPManager;

@protocol XMPPManagerDelegate <NSObject>

-(void)xmppManager:(XMPPManager *) xmppManager didReceiveNewPresenceWithBuddyItem:(BuddyItem *) buddyItem;

-(void)XMPPManager:(XMPPManager *) xmppManager didReceiveNewMessageWithMessageItem:(MessageItem *) messageItem;
-(void)XMPPManager:(XMPPManager *)xmppManager didCreateRoomSuccessWithXMPPRoom:(XMPPRoom *)xmppRoom;

@end

@interface XMPPManager : NSObject <XMPPStreamDelegate,XMPPRosterDelegate,XMPPRoomDelegate>
@property (nonatomic,strong) XMPPStream * xmppStream;//xmpp基础服务类
@property (nonatomic,strong) XMPPRoster * xmppRoster;//好友花名册，好友列表类
@property (nonatomic,strong) XMPPvCardAvatarModule * xmppvCardAvatarModule;
@property (nonatomic,assign) id<XMPPManagerDelegate> delegate;

@property (nonatomic,strong) XMPPvCardCoreDataStorage * xmppvCardStorage;
@property (nonatomic,strong) XMPPvCardTempModule * xmppvCardTempModule ;

@property (nonatomic,strong) XMPPRoom * room;

//@property (nonatomic,strong) XMPPvCardAvatarModule * xmppvCardAvatarModule;



+(id) defalutManager;

-(BOOL) connectToServer;
-(void) disconnect;
//-(XMPPRoom *) createXMPPRoom:(NSString *) roomName;
-(void) createXMPPRoom:(NSString *) roomName;
-(void)XMPPRoom:(XMPPRoom *) sender sendXMLElementToSetRoomAtrributeWithArray:(NSArray *) array;
@end
