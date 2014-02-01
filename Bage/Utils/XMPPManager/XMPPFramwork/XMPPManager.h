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
@optional


-(void)xmppManager:(XMPPManager *) xmppManager didReceiveNewPresenceWithBuddyItem:(BuddyItem *) buddyItem;

-(void)XMPPManager:(XMPPManager *) xmppManager didReceiveNewMessageWithMessageItem:(MessageItem *) messageItem;
-(void)XMPPManager:(XMPPManager *)xmppManager didCreateRoomSuccessWithXMPPRoom:(XMPPRoom *)xmppRoom;

-(void)authenticateSuccessed;
-(void)authenticateFailed;
-(void)leaveRegister;

//查询XMPPROSTER成功返回fentchControll
-(void)controllerDidChangedWithFetchedResult:(NSFetchedResultsController *)fetchedResultsController;


@end



@protocol XMPPManagerMessageDelegate <NSObject>
@optional
//查询xmppmessageachiving聊天列表成功
- (void)controllerDidChangedWithFetchedMessageArchingResult:(NSFetchedResultsController *)fetchedMessageArchivingResultsController;

@end

@interface XMPPManager : NSObject <XMPPStreamDelegate,XMPPRosterDelegate,XMPPvCardTempModuleDelegate,XMPPRoomDelegate,NSFetchedResultsControllerDelegate>


//-----------------------------------------------------------------------------------------
@property (nonatomic, retain, readonly) XMPPStream *xmppStream;
@property (nonatomic, retain, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, retain, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, retain, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, retain, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, retain, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, retain, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, retain, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, retain) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (nonatomic, retain) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

//查询roster结果
@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
//查询MessagerArchiving聊天记录结果
@property (nonatomic,retain) NSFetchedResultsController *fetchedMessageArchivingResultsController;


@property (nonatomic, retain, readonly) TURNSocket *turnSocket;
@property (nonatomic,retain) NSString *jidWithResouce;


- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (NSManagedObjectContext *)managedObjectContext_messageArchiving;

- (BOOL)connect;
- (void)disconnect;
- (void)setupStream;
- (void)teardownStream;
- (void)goOnline;
- (void)goOffline;
-(BOOL)authenticate;
//------------------------------------------------------------------------------------------
//发送消息
- (void)sendMessage:(NSString *)message;
- (void)registerInSide:(NSString *)userName andPassword:(NSString *)thePassword;
- (IBAction)addNewFriend:(NSString*)newFriendName;
- (IBAction)uploadAudio:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)printCoreData:(id)sender;

//-----------------------------------------------------------------------------------------

///单例
+(XMPPManager *)instence;
//代理
@property ( nonatomic, assign) id<XMPPManagerDelegate> delegate;
//消息代理
@property ( nonatomic, assign) id<XMPPManagerMessageDelegate> messageDelegate;

//聊天记录
@property (nonatomic, retain) NSArray *chartListsForCurrentUser;
@property(retain,nonatomic) NSMutableArray *roster;
@property (nonatomic,retain) XMPPJID *toSomeOne;
//聊天显示条数
@property (nonatomic, assign) NSInteger pageCount;

//头像
@property (nonatomic, retain) UIImage *selfHeadImage;
@property (nonatomic, retain) UIImage *friendHeadImage;
//好友列表
@property(nonatomic,retain) NSMutableArray *friendList;
//@property(nonatomic,assign) id<XMPPViewControllerDelegate> delegate;

//获得聊天记录
-(NSArray *)startLoadMessages:(NSString *)toJid;
//获得更多聊天记录
-(NSArray *)loadMoreMessages:(NSInteger)currentMessagesCount andToJid:(NSString *)toJid;
//聊天记录xmpp版
- (void)saveHistory:(XMPPMessage *)message;
//为所有好友设置头像
-(void)setFriendsHeadImage;
//显示个人头像
-(UIImage *)getOneselfHeadImage:(XMPPJID *)jid;
-(UIImage *)getMyselfHeadImage;

//添加未读消息标记
-(void)addUnReadMessageMark:(XMPPJID *)jid;
//删除未读消息
-(void)removeUnReadMessageMark;


//查询XMPPROSTER返回fentchControll
- (NSFetchedResultsController *)XMPPRosterFetchedResultsController;
//查询XMPPmessageArching返回fentchControll
- (NSFetchedResultsController *)xmppMessageArchivingFetchedResultsController;

//退出登录 删除好友列表
-(void)loginOut;

///my method
-(void)showAlertView:(NSString *)message;



@property (nonatomic,retain) XMPPvCardCoreDataStorage * xmppvCardStorage;
@property (nonatomic,retain) XMPPRoom * room;



//-(XMPPRoom *) createXMPPRoom:(NSString *) roomName;
-(void) createXMPPRoom:(NSString *) roomName;
-(void)XMPPRoom:(XMPPRoom *) sender sendXMLElementToSetRoomAtrributeWithArray:(NSArray *) array;
@end
