//
//  BagePersonChatViewController.m
//  Bage
//
//  Created by lixinda on 14-1-6.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "BagePersonChatViewController.h"

//#define kSubtitleJobs @"Jobs"
//#define kSubtitleWoz @"Steve Wozniak"
//#define kSubtitleCook @"Mr. Cook"


@interface BagePersonChatViewController ()

@end

@implementation BagePersonChatViewController

@synthesize messageArray;
@synthesize fetchedMessageResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.frame = CGRectMake(0, 60, 320, 523);
    }
    return self;
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    [[XMPPManager instence]setMessageDelegate:self];
    self.title = [XMPPManager instence].toSomeOne.user;
    

    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.messageArray = [[NSMutableArray alloc]init];
    
    [self getMessagesFromFetchedRequest];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPMessageArching Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)getMessagesFromFetchedRequest
{
    self.fetchedMessageResultsController = [[XMPPManager instence]xmppMessageArchivingFetchedResultsController];

    NSArray *arr = [fetchedMessageResultsController fetchedObjects];
    NSLog(@"%d",arr.count);

}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPMessageDelegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询xmppmessageachiving聊天列表成功
- (void)controllerDidChangedWithFetchedMessageArchingResult:(NSFetchedResultsController *)fetchedMessageArchivingResultsController
{
    [self getMessagesFromFetchedRequest];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[self.fetchedMessageResultsController fetchedObjects].count);
    return [self.fetchedMessageResultsController fetchedObjects].count;
}

#pragma mark - Messages view delegate
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [[XMPPManager instence]sendMessage:text];
    
//    if((self.messageArray.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
//    else
//        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}

- (void)cameraPressed:(id)sender{
    
    [self.inputToolBarView.textView resignFirstResponder];
   
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *amessage = [fetchedMessageResultsController objectAtIndexPath:indexPath];
    if (amessage.isOutgoing) {
        return JSBubbleMessageTypeOutgoing;
    }else
        return JSBubbleMessageTypeIncoming;
    
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *amessage = [fetchedMessageResultsController objectAtIndexPath:indexPath];
    
    return JSBubbleMediaTypeText;
    
    if([amessage.body hasPrefix:@"sound"]){
        return JSBubbleMediaTypeImage;
    }else {
        return JSBubbleMediaTypeText;
    }
    
    return -1;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyEveryThree;
}


- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPMessageArchiving_Message_CoreDataObject *amessage = [fetchedMessageResultsController objectAtIndexPath:indexPath];

    if(amessage){
        return amessage.body;
    }
    return nil;
}

//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.timestamps objectAtIndex:indexPath.row];
//}

- (UIImage *)avatarImageForIncomingMessage
{
    return [XMPPManager instence].selfHeadImage;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    
    return [[XMPPManager instence]getOneselfHeadImage:[XMPPManager instence].toSomeOne];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *amessage = [fetchedMessageResultsController objectAtIndexPath:indexPath];
    
    if([amessage.body hasPrefix:@"sound"]){
        return amessage.body;
        }
    return nil;
    
}
//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

//- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MessageItem * message = [self.messageItemArray objectAtIndex:indexPath.row];
//    return message.messageFromName;
//}


#pragma mark - private methods -


-(void)sendText:(NSString *)text{
    XMPPMessage * message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.title,kXMPPHostName]]];
    [message addBody:text];
    [[[XMPPManager instence]xmppStream] sendElement:message];
}
#pragma mark - XMPPManager Delegate Methods -


-(void)XMPPManager:(XMPPManager *)xmppManager didReceiveNewMessageWithMessageItem:(MessageItem *)messageItem{
    


        [JSMessageSoundEffect playMessageSentSound];

    
    [self finishSend];
    [self scrollToBottomAnimated:YES];

    
}
@end
