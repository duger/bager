//
//  BagePersonChatViewController.m
//  Bage
//
//  Created by lixinda on 14-1-6.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "BagePersonChatViewController.h"

#define kSubtitleJobs @"Jobs"
#define kSubtitleWoz @"Steve Wozniak"
#define kSubtitleCook @"Mr. Cook"


@interface BagePersonChatViewController ()

@end

@implementation BagePersonChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    [[XMPPManager defalutManager]setDelegate:self];
//    self.title = @"Messages";
    
    self.messageInputView.textView.placeHolder = @"New Message";
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.messageItemArray = [NSMutableArray array];
    
//    self.messages = [[NSMutableArray alloc] initWithObjects:
//                     @"JSMessagesViewController is simple and easy to use.",
//                     @"It's highly customizable.",
//                     @"It even has data detectors. You can call me tonight. My cell number is 452-123-4567. \nMy website is www.hexedbits.com.",
//                     @"Group chat is possible. Sound effects and images included. Animations are smooth. Messages can be of arbitrary size!",
//                     nil];
    
//    self.timestamps = [[NSMutableArray alloc] initWithObjects:
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate distantPast],
//                       [NSDate date],
//                       nil];
    
//    self.subtitles = [[NSMutableArray alloc] initWithObjects:
//                      kSubtitleJobs,
//                      kSubtitleWoz,
//                      kSubtitleJobs,
//                      kSubtitleCook, nil];
    
    self.avatars = [[NSDictionary alloc] initWithObjectsAndKeys:
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-jobs" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleJobs,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-woz" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleWoz,
                    [JSAvatarImageFactory avatarImageNamed:@"demo-avatar-cook" style:JSAvatarImageStyleFlat shape:JSAvatarImageShapeCircle], kSubtitleCook,
                    nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self
                                                                                           action:@selector(buttonPressed:)];
}

- (void)buttonPressed:(UIButton *)sender
{
    // Testing pushing/popping messages view
//    JSDemoViewController *vc = [[JSDemoViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageItemArray.count;
}

#pragma mark - Messages view delegate: REQUIRED

- (void)didSendText:(NSString *)text
{
    [self sendText:text];
    
//    [self.messages addObject:text];
//    
//    [self.timestamps addObject:[NSDate date]];
//    
//    if((self.messages.count - 1) % 2) {
//        [JSMessageSoundEffect playMessageSentSound];
//        
//        [self.subtitles addObject:arc4random_uniform(100) % 2 ? kSubtitleCook : kSubtitleWoz];
//    }
//    else {
//        [JSMessageSoundEffect playMessageReceivedSound];
//        
//        [self.subtitles addObject:kSubtitleJobs];
//    }
//    
//    [self finishSend];
//    [self scrollToBottomAnimated:YES];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message = [self.messageItemArray objectAtIndex:indexPath.row];
    
    return message.isComposing ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type
                       forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message = [self.messageItemArray objectAtIndex:indexPath.row];
    if(message.isComposing) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_iOS7lightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_iOS7blueColor]];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyAll;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyAll;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages view delegate: OPTIONAL

//
//  *** Implement to customize cell further
//
- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        [cell.bubbleView setTextColor:[UIColor whiteColor]];
        
        if([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:UITextAttributeTextColor];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if(cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if(cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
}

//  *** Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

//  *** Implement to use a custom send button
//
//  The button's frame is set automatically for you
//
//  - (UIButton *)sendButtonForInputView
//

//  *** Implement to prevent auto-scrolling when message is added
//
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message =[self.messageItemArray objectAtIndex:indexPath.row];
//    return [self.messages objectAtIndex:indexPath.row];
    return message.messageText;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message =[self.messageItemArray objectAtIndex:indexPath.row];
    return message.receivedDate;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message = [self.messageItemArray objectAtIndex:indexPath.row];
    NSString *subtitle = message.messageFromName;
    
    UIImage *image = [self.avatars objectForKey:subtitle];
    return [[UIImageView alloc] initWithImage:image];
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem * message = [self.messageItemArray objectAtIndex:indexPath.row];
    return message.messageFromName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private methods -
-(void)sendText:(NSString *)text{
    XMPPMessage * message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.title,kXMPPHostName]]];
    [message addBody:text];
    [[[XMPPManager defalutManager]xmppStream] sendElement:message];
}
#pragma mark - XMPPManager Delegate Methods -
-(void)XMPPManager:(XMPPManager *)xmppManager didReceiveNewMessageWithMessageItem:(MessageItem *)messageItem{
    

    [self.messageItemArray addObject:messageItem];
    if(messageItem.isComposing) {
        [JSMessageSoundEffect playMessageSentSound];
    }
    else {
        [JSMessageSoundEffect playMessageReceivedSound];
        
        messageItem.messageFromName =[[ToolsClass instance]cutString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName] OfSubStr:kXMPPHostName];
    }
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];

    
}
@end
