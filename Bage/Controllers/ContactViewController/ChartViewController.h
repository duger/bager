//
//  ChartViewController.h
//  XMPP
//
//  Created by Duger on 13-10-22.
//  Copyright (c) 2013年 Dawn_wdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "MJRefresh.h"
#import "XMPPManager.h"
#import "BageCustonButton.h"

#import "lame.h"

@interface ChartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MJRefreshBaseViewDelegate,XMPPManagerMessageDelegate,AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    
        
    
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UITextField *enterTextField;

@property (retain, nonatomic) IBOutlet UITableView *tableView;


//@property (nonatomic, retain) IBOutlet FaceViewController   *phraseViewController;
@property (nonatomic, retain) NSString               *phraseString;
@property (nonatomic, retain) NSString               *titleString;
@property (nonatomic, retain) NSMutableString        *messageString;
@property (nonatomic, retain) NSMutableArray		 *chatArray;

@property (nonatomic, retain) NSDate                 *lastTime;
@property (nonatomic,retain) XMPPJID *toSomeOne;
//拖至此取消提示
@property (retain, nonatomic) IBOutlet UILabel *tipLabel;

@property (retain, nonatomic) AVAudioPlayer *avPlay;
@property(nonatomic,retain) NSData *soundsData;
//头像
@property (nonatomic, strong) UIImage *selfHeadImage;
@property (nonatomic, strong) UIImage *friendHeadImage;

//发送消息
- (IBAction)didClickSendButton:(UIBarButtonItem *)sender;
//开始录音
- (IBAction)beginAudio:(id)sender;
//完成录音
- (IBAction)endAudio:(id)sender;
//取消录音
- (IBAction)cancelAudio:(id)sender;



//消息列表
@property (strong, nonatomic) NSFetchedResultsController *fetchedMessageResultsController;

@end
