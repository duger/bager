//
//  XMPPManager.m
//  Bage
//
//  Created by lixinda on 13-12-27.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "XMPPManager.h"

@interface XMPPManager ()

-(void)_setup;

@end

static XMPPManager * s_XmppManager=nil;
@implementation XMPPManager
#pragma mark - publick methods -
+(id) defalutManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_XmppManager == nil) {
            s_XmppManager = [[XMPPManager alloc]init];
        }
    });
    return s_XmppManager;
}

-(BOOL) connectToServer{
    [self _setup];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userJID = nil;
    NSString * userPassword = nil;
    userJID = [userDefault stringForKey:@"kUserName"];
    userPassword = [userDefault stringForKey:@"kUserPassword"];
    NSString * serverIP = kXMPPServerIP;
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    if (userJID == nil || userPassword == nil) {
        return NO;
    }
//    XMPPJID * jid = [XMPPJID jidWithString:userJID resource:kClientResource];
//    XMPPJID * jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userJID,@"124.205.147.26"]];
    XMPPJID * jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",@"lxd",kXMPPHostName]];
    
    [self.xmppStream setMyJID:jid];
    [self.xmppStream setHostName:serverIP];
    [self.xmppStream setHostPort:kXMPPServerPort];
    
    NSError * error = nil;
    if (![self.xmppStream connectWithTimeout:10.0f error:&error]) {
        NSLog(@"链接服务器失败:%@",error.description);
        return NO;
    }
    return YES;
}
-(void) disconnect{
    [self _userOfflineStatus];
    [self.xmppStream disconnect];
}
-(void) createXMPPRoom:(NSString *) roomName{
    
    XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
    XMPPJID * xmppJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",roomName,kXMPPHostNameForRoom]];
    //    NSLog(@"%@",xmppJID);
    self.room = [[XMPPRoom alloc]initWithRoomStorage:rosterstorage jid:xmppJID];
    [self.room activate:self.xmppStream];
    if (self.room) {
        NSLog(@"房间创建");
    }
    [self.room joinRoomUsingNickname:self.xmppStream.myJID.description history:nil];
    //    [xmppRoom fetchConfigurationForm];
    //    [xmppRoom configureRoomUsingOptions:nil];
    [self.room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    
    

    
}
//-(XMPPRoom *) createXMPPRoom:(NSString *) roomName{
//
//    XMPPRoomCoreDataStorage *rosterstorage = [XMPPRoomCoreDataStorage sharedInstance];
//    XMPPJID * xmppJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",roomName,kXMPPHostNameForRoom]];
////    NSLog(@"%@",xmppJID);
//    XMPPRoom * xmppRoom = [[XMPPRoom alloc]initWithRoomStorage:rosterstorage jid:xmppJID];
//    [xmppRoom activate:self.xmppStream];
//    if (xmppRoom) {
//        NSLog(@"房间创建");
//    }
//    [xmppRoom joinRoomUsingNickname:self.xmppStream.myJID.description history:nil];
//
////    [xmppRoom fetchConfigurationForm];
////    [xmppRoom configureRoomUsingOptions:nil];
//    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    return xmppRoom;
//}


#pragma mark - private methods -
-(void)_setup{
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc]init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    if (self.xmppRoster == nil) {
        XMPPRosterCoreDataStorage * rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:rosterStorage dispatchQueue:dispatch_get_main_queue()];
        [self.xmppRoster activate:self.xmppStream];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }


    if (self.xmppvCardAvatarModule == nil) {
        XMPPvCardCoreDataStorage * xmppvCardTCoreDataStorage = [XMPPvCardCoreDataStorage sharedInstance];
        XMPPvCardTempModule * xmppvCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:xmppvCardTCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        [xmppvCardTempModule activate:self.xmppStream];
        
        self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:xmppvCardTempModule dispatchQueue:dispatch_get_main_queue()];
        [self.xmppvCardAvatarModule activate:self.xmppStream];
    }
}

-(void) _userOnlineStatus{
    XMPPPresence * onlinePresence = [XMPPPresence presenceWithType:@"avaliable"];
    [self.xmppStream sendElement:onlinePresence];
}
-(void) _userOfflineStatus{
    XMPPPresence * offlinePresence = [XMPPPresence presenceWithType:@"unavaliable"];
    [self.xmppStream sendElement:offlinePresence];
}
#pragma mark - XMPPStream Delegate -
-(void) xmppStreamDidConnect:(XMPPStream *)sender{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isRegister = [userDefaults boolForKey:@"kRegister"];
    NSString * password = [userDefaults stringForKey:@"kUserPassword"];
    if (isRegister) {
        [self.xmppStream registerWithPassword:password error:nil];
    }else{
        [self.xmppStream authenticateWithPassword:password error:nil];
    }
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"%@",error.description);
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self _userOnlineStatus];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kLoginSucceed" object:nil];
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%@",error.description);
}
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册新用户成功");
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"kUserPassword"];
    [self.xmppStream authenticateWithPassword:password error:nil];
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败:%@",error.description);
}

#pragma mark - XMPPoster Delegate Methods -
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
   
    NSLog(@"%@",item);
}


-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{

    //分辨自己还是好友
    if (![presence.from.bareJID isEqualToJID:presence.to.bareJID]) {
        BuddyItem * newBuddy = [[BuddyItem alloc]initWithPresence:presence];
        NSData *photoData = [self.xmppvCardAvatarModule photoDataForJID:presence.from.bareJID];
        newBuddy.headerImage = [UIImage imageWithData:photoData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(xmppManager:didReceiveNewPresenceWithBuddyItem:)]) {
            [self.delegate xmppManager:self didReceiveNewPresenceWithBuddyItem:newBuddy];
    }
    }
    
}
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    MessageItem * messageItem = [[MessageItem alloc]initWithMessage:message andIsComposing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(XMPPManager:didReceiveNewMessageWithMessageItem:)]) {
        [self.delegate XMPPManager:self didReceiveNewMessageWithMessageItem:messageItem];
    }
}

-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    MessageItem * messageItem = [[MessageItem alloc]initWithMessage:message andIsComposing:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(XMPPManager:didReceiveNewMessageWithMessageItem:)]) {
        [self.delegate XMPPManager:self didReceiveNewMessageWithMessageItem:messageItem];
    }
}

#pragma mark - XMPPRoomDelegate -
- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    NSLog(@"sender&&&&%@",sender);
    [sender fetchConfigurationForm];
    [sender fetchBanList];
    [sender fetchMembersList];
    [sender fetchModeratorsList];
    [sender joinRoomUsingNickname:@"quack" history:nil];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(XMPPManager:didCreateRoomSuccessWithXMPPRoom:)]) {
        [self.delegate XMPPManager:self didCreateRoomSuccessWithXMPPRoom:sender];
    }
    
    
}

-(void)XMPPRoom:(XMPPRoom *) sender sendXMLElementToSetRoomAtrributeWithArray:(NSArray *) array{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x"];
    
    [x addAttributeWithName:@"xmlns" stringValue:@"jabber:x:data"];
    
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    //生成XML消息文档
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/muc#owner"];
    
    //消息类型
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    
    //发送给谁
    
    [iq addAttributeWithName:@"to" stringValue:sender.myRoomJID.description];
    
    //由谁发送
    
    [iq addAttributeWithName:@"from" stringValue:self.xmppStream.myJID.description];
    
    //iq类型
    
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    
    //组合
    
    [query addChild:x];
    
    [iq addChild:query];
    
    for (NSXMLElement * item in array) {
        [x addChild:item];
    }
    
//    [x addChild:field];
    NSLog(@"wd %@", iq);
    
    //发送消息
    
    [[self xmppStream] sendElement:iq];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    
    //    <field
    //    label='Make Room Persistent?'
    //    type='boolean'
    //    var='muc#roomconfig_persistentroom'>
    //    <value>0</value>
    //    </field>
    NSXMLElement * field = [NSXMLElement elementWithName:@"field"];
    [field addAttributeWithName:@"label" stringValue:@"Make Room Persistent?"];
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];
    NSXMLElement * value = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [field addChild:value];
    [self XMPPRoom:sender  sendXMLElementToSetRoomAtrributeWithArray:@[field]];
    
}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm
{
    NSLog(@"22222222222222222");
}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    NSLog(@"3333333333333333333");
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    NSLog(@"4444444444444");
}


@end
