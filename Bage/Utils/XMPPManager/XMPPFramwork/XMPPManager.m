//
//  XMPPManager.m
//  Bage
//
//  Created by lixinda on 13-12-27.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "XMPPManager.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "Base64.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "NSXMLElement+XMPP.h"

#define tag_subcribe_alertView 10

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface XMPPManager ()
{
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPSearch *xmppSearch;
    
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    
    NSString *password;
    
    NSManagedObjectContext *managedObjectContext_roster;
	NSManagedObjectContext *managedObjectContext_capabilities;
    NSManagedObjectContext *managedObjectContext_messageArchiving;
    
    //是注册还是登陆
    BOOL isRegister;
}



@end



@implementation XMPPManager


static XMPPManager * s_XmppManager = nil;

+(XMPPManager *)instence{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_XmppManager == nil) {
            s_XmppManager = [[XMPPManager alloc]init];
        }
    });
    return s_XmppManager;
}

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize turnSocket;
@synthesize jidWithResouce;


@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppMessageArchivingModule;
@synthesize chartListsForCurrentUser;
@synthesize friendList;


@synthesize fetchedResultsController;
@synthesize fetchedMessageArchivingResultsController;

- (id)init
{
    self = [super init];
    if (self) {
        
        
        password = [[NSString alloc]init];
        
        jidWithResouce = [[NSString alloc] init];
        
        self.roster = [[NSMutableArray alloc]init];
        
        self.friendHeadImage = [[UIImage alloc]init];
        //        chartListsForCurrentUser = [[NSMutableArray alloc]init];
    }
    return self;
}



- (void)dealloc
{
	[self teardownStream];
    [super dealloc];
}


- (void)setupStream{
    
    xmppStream = [[XMPPStream alloc] init];
    
    [xmppStream setHostName:kHOSTNAME];
	[xmppStream setHostPort:5222];
    // Setup reconnect

	
    //把意外断开重新连接回去！！
	xmppReconnect = [[XMPPReconnect alloc] init];
	

#if !TARGET_IPHONE_SIMULATOR
    {
        //支持后台运行，虚拟机不支持
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];

	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	//好友的详细信息  如头像
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
    
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    xmppSearch = [[XMPPSearch alloc]init];
    
    
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    [xmppSearch            activate:xmppStream];
    [xmppMessageArchivingModule activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppSearch addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	
    
	
    allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
    
}

- (void)teardownStream
{
    [self.roster removeAllObjects];
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
    
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
    [xmppSearch            deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)connect
{
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
    NSLog(@"%@",myJID);
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	myJID = [NSString stringWithFormat:@"%@@%@",myJID,kDOMAIN];
    //    myPassword = self.passwordTextField.text;
	
    XMPPJID *jid = [XMPPJID jidWithString:myJID resource:@"DianDianer"];
	[xmppStream setMyJID:jid];
	password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        NSLog(@"%@",@"error connecting");
        
		return NO;
	}

    return YES;
    
}

- (void)disconnect
{
    [self.roster removeAllObjects];
	[self goOffline];
	[xmppStream disconnect];
}

//验证用户
-(BOOL)authenticate
{
    if ([xmppStream isDisconnected]) {
        NSLog(@"未连接成功！！");
        return NO;
    }
    NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
    NSLog(@"%@",myJID);
    //
    // If you don't want to use the Settings view to set the JID,
    // uncomment the section below to hard code a JID and password.
    //
    // myJID = @"user@gmail.com/xmppframework";
    // myPassword = @"";
    
    if (myJID == nil || myPassword == nil) {
        return NO;
    }
    
    myJID = [NSString stringWithFormat:@"%@@%@",myJID,kDOMAIN];
    
    
    XMPPJID *jid = [XMPPJID jidWithString:myJID resource:@"DianDianer"];
    [xmppStream setMyJID:jid];
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream authenticateWithPassword:password error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        NSLog(@"%@",@"error authenticate!1");
        
        return NO;
    }
    return YES;
    
    
}



#pragma mark - Online OffLine

- (void)goOnline
{
    NSLog(@"goOnline");
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    NSLog(@"goOffline");
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Send Messager
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendMessage:(NSString *)message {
    NSXMLElement *xmlBody = [NSXMLElement elementWithName:@"body"];
    [xmlBody setStringValue:message];
    NSXMLElement *xmlMessage = [NSXMLElement elementWithName:@"message"];
    [xmlMessage addAttributeWithName:@"type" stringValue:@"chat"];
    [xmlMessage addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@",self.toSomeOne]];
    [xmlMessage addChild:xmlBody];
    [self.xmppStream sendElement:xmlMessage];
    
    //    [XMPPManager instence].toSomeOne = self.toTextField.text;
    //    NSMutableDictionary *msgAsDictionary = [[NSMutableDictionary alloc] init];
    //    [msgAsDictionary setObject:self.messageTextField.text forKey:@"message"];
    //    [msgAsDictionary setObject:@"you" forKey:@"sender"];
    //    [self.messages addObject:msgAsDictionary];
    NSLog(@"From: You, Message: %@", message);
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Regsiter
//注册
- (void)registerInSide:(NSString *)userName andPassword:(NSString *)thePassword{
    isRegister = YES;
    NSError *err;
    NSString *tjid = [[NSString alloc] initWithFormat:@"%@@%@",userName,kDOMAIN];  //smack
    password = [thePassword copy];
    XMPPJID *jid = [XMPPJID jidWithString:tjid];
    [tjid release];
    NSLog(@"%@",jid);
    [xmppStream setMyJID:jid];
    
    
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        NSLog(@"注册 连接失败Error: %@",err);
        [[NSNotificationCenter defaultCenter]postNotificationName:kResigterError object:nil userInfo:@{@"result": err}];
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark User Info
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//获得自己的头像
- (void)_getMyselfHeadImage
{
    NSManagedObjectContext *moc = [self managedObjectContext_roster];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    //查询自己
    NSString *JID = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    JID = [JID stringByAppendingFormat:@"@%@",kDOMAIN];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidStr == %@",JID];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    //		[fetchRequest setFetchBatchSize:10];
    
    
    NSError *error = nil;
    NSArray *arr = [moc executeFetchRequest:fetchRequest error:&error];
    XMPPUserCoreDataStorageObject *user;
    if (arr.count >= 0) {
        user = [arr lastObject];
    }
    
    
    if (error)
    {
        DDLogError(@"Error performing fetch: %@", error);
        //            NSLog(@"Error performing fetch: %@", error);
    }
    if (user.photo != nil)
	{
		self.selfHeadImage = user.photo;
	}
	else
	{
		NSData *photoData = [[self xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			self.selfHeadImage = [UIImage imageWithData:photoData];
		else
			self.selfHeadImage = [UIImage imageNamed:@"Icon-72.png"];
	}
    
}

-(UIImage *)getMyselfHeadImage
{
    UIImage *image = [self getOneselfHeadImage:xmppStream.myJID];
    return image;
}

//显示个人头像
-(UIImage *)getOneselfHeadImage:(XMPPJID *)jid
{
//    XMPPJID *userJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,kDOMAIN]];
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:jid xmppStream:xmppStream managedObjectContext:[self managedObjectContext_roster]];
    
    UIImage *userImage = nil;

    
    if (user.photo != nil) {
        userImage = user.photo;
    }
    else{
        NSData *photoData = [xmppvCardAvatarModule photoDataForJID:user.jid];
        
        if (photoData != nil) {
            userImage = [[[UIImage alloc]initWithData:photoData]autorelease];
            
        }else{
            userImage = [UIImage imageNamed:@"DefaultHead.png"];
    
        }
    }
    
    
    
    return userImage;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UnReadMessagers Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//添加未读消息标记
-(void)addUnReadMessageMark:(XMPPJID *)jid
{
    NSManagedObjectContext *moc = [self managedObjectContext_roster];
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:jid     xmppStream:xmppStream
                                                   managedObjectContext:moc];
    NSLog(@"%ld",[user.unreadMessages integerValue]);
    
    user.unreadMessages = [NSNumber numberWithInteger:([user.unreadMessages integerValue] + 1)];
}
//删除未读消息
-(void)removeUnReadMessageMark
{
    NSLog(@"%@",self.toSomeOne);
    NSManagedObjectContext *moc = [self managedObjectContext_roster];
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:self.toSomeOne xmppStream:xmppStream
                                                   managedObjectContext:moc];
    NSLog(@"%ld",[user.unreadMessages integerValue]);
    
    user.unreadMessages = @0;
    NSLog(@"%ld",[user.unreadMessages integerValue]);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSManagedObjectContext *)managedObjectContext_roster
{
	NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
    managedObjectContext_roster = [xmppRosterStorage mainThreadManagedObjectContext];
    
    return managedObjectContext_roster;
}

- (NSManagedObjectContext *)managedObjectContext_messageArchiving
{
    NSAssert([NSThread isMainThread],
	         @"NSManagedObjectContext is not thread safe. It must always be used on the same thread/queue");
    managedObjectContext_messageArchiving = [xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    return managedObjectContext_messageArchiving;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPRoom Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPROSTER Method
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//退出登录 删除好友列表
-(void)loginOut
{
//    [xmppRoster removeAllUsersAndResources];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kLoginOrNot];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
    
    [self goOffline];
	[xmppStream disconnect];
}


- (NSFetchedResultsController *)XMPPRosterFetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [self managedObjectContext_roster];
        
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
        //按状态分组和按名字排序
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc]initWithKey:@"unreadMessages" ascending:NO];
		NSSortDescriptor *sd3 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, sd3, nil];
        [sd1 release];
        [sd2 release];
        [sd3 release];
        
        //添加按条件查询 剔除自己
        NSString *JID = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
        JID = [JID stringByAppendingFormat:@"@%@",kDOMAIN];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jidStr != %@",JID];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:predicate];
        //        [fetchRequest setFetchBatchSize:10];
		
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
        [fetchRequest release];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
            DDLogError(@"Error performing fetch: %@", error);
            //            NSLog(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPMessage Method
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询消息记录
- (NSFetchedResultsController *)xmppMessageArchivingFetchedResultsController
{
    
    NSManagedObjectContext *moc = [self managedObjectContext_messageArchiving];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:moc];
    //添加按条件查询
    NSString *JID = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    JID = [JID stringByAppendingFormat:@"@%@",kDOMAIN];
    NSLog(@"查询的自己%@",JID);
    NSLog(@"查询的别人%@",self.toSomeOne);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",JID,self.toSomeOne.bare];
    
    //按时间 和 好友排序
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc]initWithKey:@"bareJidStr" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
    [sd1 release];
    [sd2 release];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchLimit:self.pageCount];
    //        [fetchRequest setFetchBatchSize:20];
    
    if (fetchedMessageArchivingResultsController == nil) {
        fetchedMessageArchivingResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        
    }else{
        [fetchedMessageArchivingResultsController setValue:fetchRequest forKey:@"fetchRequest"];
    }
//    [fetchRequest release];
    
    [fetchedMessageArchivingResultsController setDelegate:self];
    
    NSError *error = nil;
    
    if (![fetchedMessageArchivingResultsController performFetch:&error]) {
        DDLogError(@"Error performing fetch:%@",error);
    }
    
    
    
    [self desortFetchedMessageResultsController:fetchedMessageArchivingResultsController];
    
    
    
    
    return fetchedMessageArchivingResultsController;
}

-(void)desortFetchedMessageResultsController:(NSFetchedResultsController *)control
{
    
    NSArray *Arr = [control fetchedObjects];
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (id item in Arr) {
        [tempArr insertObject:item atIndex:0];
    }
    [control setValue:tempArr forKey:@"fetchedObjects"];
    [tempArr release];
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSFetchedResultsController Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
    NSLog(@"%@",controller.cacheName);
    if (controller == fetchedResultsController) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(controllerDidChangedWithFetchedResult:)])
        {
            [self.delegate controllerDidChangedWithFetchedResult:controller];
        }
    }
    
    if (controller == fetchedMessageArchivingResultsController) {
        if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(controllerDidChangedWithFetchedMessageArchingResult:)]) {
            [self.messageDelegate controllerDidChangedWithFetchedMessageArchingResult:controller];
        }
        
    }
    
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



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidRegister");
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *str = [NSString stringWithFormat:@"创建成功！\n欢迎你%@",sender.myJID.user];
    //发送注册成功通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kResigterSuccess object:nil userInfo:@{@"result": str}];
    
    //断开连接
    [xmppStream disconnect];
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"%@",error.description);
    //发送注册失败通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kResigterError object:nil userInfo:@{@"result": @"已存在用户"}];
    //断开连接
    [xmppStream disconnect];
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidConnect");

	NSError *error = nil;
    if (isRegister) {
        isRegister = !isRegister;
        NSError *err;
        if (![xmppStream registerWithPassword:password error:&err]) {
            NSLog(@"Error Registering: %@",error);
        };
        return;
    }
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
        NSLog(@"Error authenticating: %@", error);
	}

}


-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"Error ConnectingWithError %@",error.description);
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"xmppStreamDidAuthenticate");

    //上线
	[self goOnline];
    //发送登陆成功通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginedSuccess object:nil userInfo:@{@"result": @"登陆成功！"}];
    //获得自己的头像
    [self _getMyselfHeadImage];
    
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error

{
    NSLog(@"didNotAuthenticate : %@",error.description);
    //发送验证失败通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginedError object:nil userInfo:@{@"result": @"用户名或密码错误！"}];
    
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    NSLog(@"didSendIQ ----------%@",iq.description);
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"didReceiveIQ :++++++++++ %@",iq.description);

	return YES;
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    //    NSLog(@"did send message : %@",message.description);
    //    [self saveHistory:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"didReceiveMessage ： %@",message.description);
	// A simple example of inbound message handling.
    
    //    [self.delegate showMessage:message];
    
    
	if ([message isChatMessageWithBody])
	{
        NSManagedObjectContext *moc = [self managedObjectContext_roster];
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:moc];
        
		NSLog(@"%d",[user.unreadMessages integerValue]);
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
        //添加未读标记
        [self addUnReadMessageMark:[message from]];
        
        
        NSLog(@"%d",[user.unreadMessages integerValue]);
        //        [moc save:nil];
        
        if ([message isOfflineMessageWithBody]) {
            
        }
        
        //是语音
        if ([body hasPrefix:@"base64"]) {
            NSString *soundstring = [body substringFromIndex:6];
            NSData *soundData = [soundstring base64DecodedData];
            NSString *path = [[self soundsAtDocumentPath] stringByAppendingString:@"/receieved.mp3"];
            if ([soundData writeToFile:path atomically:YES]) {
                NSLog(@"写入成功");
            }
            
//        if ([message elementForName:@"attachment"] != nil) {

//            if ([[[message elementForName:@"body"]stringValue]isEqualToString:@"image"]) {
//                NSLog(@"收到图片");
//                NSString *imageStr = [[message elementForName:@"attachment"]stringValue];
//                NSData *imageData = [imageStr base64DecodedData];
//                UIImage *image = [[UIImage alloc]initWithData:imageData];
////            }
            
//            if ([[[message elementForName:@"body"]stringValue]isEqualToString:@"body"]) {
//                NSString *soundStr = [[message elementForName:@"attachment"]stringValue];
//                NSData *soundData = [soundStr base64DecodedData];
//                NSString *path = [[self soundsAtDocumentPath] stringByAppendingString:@"/receieved.mp3"];
//                if ([soundData writeToFile:path atomically:YES]) {
//                    NSLog(@"写入成功");
//                }
//                
//            }
            
        
        
        }
        
        
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
            
            if (![[NSUserDefaults standardUserDefaults]objectForKey:kisChartingOrNot]) {
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertAction = @"Ok";
                localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
                
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                [localNotification release];
            }
            
            
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            [localNotification release];
		}
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"didReceivePresence : %@",presence.description);
    //    if (![presence.type isEqualToString:@"error"]) {
    //        self.jidWithResouce = presence.fromStr;
    //    }
    //    NSLog(@"jidWithResouce : %@",jidWithResouce);
    
}

-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSLog(@"didReceiveSubsriptionRequest : %@",presence.description);
    if ([presence.type isEqualToString:@"subscribe"]) {
        NSString *message = [NSString stringWithFormat:@"%@想要添加你为好友！",presence.fromStr];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:presence.fromStr message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
            alertView.tag = tag_subcribe_alertView;
            [alertView show];
            [alertView release];
        }else{
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"OK";
            localNotification.alertBody = message;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            localNotification.applicationIconBadgeNumber += 1;
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            [localNotification release];
        }
        
    }
}


#pragma mark - XMPPRoster Delegate Methods

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
   
    NSLog(@"%@",item);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	NSLog(@"%@",displayName);
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
        [alertView release];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [localNotification release];
	}
	
}

-(void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender {
    NSLog(@"users: %@", [sender unsortedUsers]);
    // My subscribed users do print out
}

#pragma mark - XMPPRoomDelegate
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

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XMPPJID *jid = [XMPPJID jidWithString:alertView.title];
    if (alertView.tag == tag_subcribe_alertView && buttonIndex == 1) {
        
        [[self xmppRoster] acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }else{
        [[self xmppRoster] rejectPresenceSubscriptionRequestFrom:jid];
    }
}


#pragma mark - Private Methods
//创建sounds文件夹
-(NSString *)soundsAtDocumentPath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents lastObject];
    NSString *soundsPath = [documentsPath stringByAppendingString:@"/sounds"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:soundsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return soundsPath;
}


@end
