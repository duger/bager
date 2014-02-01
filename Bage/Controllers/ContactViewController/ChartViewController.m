//
//  ChartViewController.m
//  XMPP
//
//  Created by Duger on 13-10-22.
//  Copyright (c) 2013年 Dawn_wdf. All rights reserved.
//

#import "ChartViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "ChartCell.h"


#import "Base64.h"

#import "XMPPManager.h"
//#import "FaceViewController.h"
//#import "Messages.h"

#import "MJRefreshBaseView.h"
#import "MJRefreshHeaderView.h"

#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define kDidReceiveChat @"didReceiveChat"

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface ChartViewController ()
{
    //下拉刷新中
    //区分下拉刷新更新消息和收发信息更新消息
    BOOL _isMJRefreshing;
    BOOL isAudio;

    
}

@property (copy, nonatomic) NSString *originWav;

@end

@implementation ChartViewController
{
    
    NSString                   *_titleString;
    NSMutableString            *_messageString;
    NSString                   *_phraseString;
    NSMutableArray		       *_chatArray;
    
    UITableView                *_chatTableView;
    UITextField                *_messageTextField;
    BOOL                       _isFromNewSMS;

    
    NSDate                     *_lastTime;
    MJRefreshHeaderView      *_header;
    
    NSURL *urlPlay;
    NSMutableData *mutableData;
    NSString *soundsPath;
    NSString *path;
    NSString *mp3FilePath;

    
    //头像
    UIImage *selfHeadImage;
    UIImage *friendHeadImage;
    
}


@synthesize soundsData = _soundsData;

@synthesize avPlay = _avPlay;

@synthesize originWav;
@synthesize fetchedMessageResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.chatArray = [[NSMutableArray alloc] init];
        
        //是否正在下拉刷新
        _isMJRefreshing = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.chatArray = [[NSMutableArray alloc] init];
        
        //是否正在下拉刷新
        _isMJRefreshing = NO;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toSomeOne = [XMPPManager instence].toSomeOne;
    
    [[XMPPManager instence]setMessageDelegate:self];
    
    //录音
    [self soundsAtDocumentPath];
    
    [self audio];
    
    //导航栏 对方的名字

    NSLog(@"%@",self.toSomeOne.bare);

    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChartCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];

    //头像
    selfHeadImage =[[UIImage alloc]init];
    selfHeadImage = [[XMPPManager instence]getMyselfHeadImage];
    friendHeadImage = [[UIImage alloc]init];
    friendHeadImage = [[XMPPManager instence] getOneselfHeadImage:self.toSomeOne];
    NSLog(@"%@",self.toSomeOne);
    
    //获得好友聊天记录
    [self getMessagesFromFetchedRequest];
    
    //下拉查看更多
    _header = [[MJRefreshHeaderView alloc]init];
    [_header setScrollView:self.tableView];
    _header.delegate = self;
    [_header.arrowImage removeFromSuperview];
    _header.backgroundColor = [UIColor clearColor];


    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone5-backpic.png"]];



    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mkeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    if (self.chatArray.count > 5) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:NO];
    }
    
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XMPPManager instence].messageDelegate = nil;
    [XMPPManager instence].fetchedMessageArchivingResultsController = nil;
    //把默认消息个数恢复为默认
    [XMPPManager instence].pageCount = kPageCount;
    //删除未读消息
    [[XMPPManager instence]removeUnReadMessageMark];
    
}

-(void)dealloc
{
//    [_tipLabel release];

    
    [_header free];
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
    [self getPopChartList:arr];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - XMPPMessageDelegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//XMPPMessageAching中查询聊天列表
//fetchedResultsController接到消息改变时回调此方法
-(void)controllerDidChangedWithFetchedMessageArchingResult:(NSFetchedResultsController *)fetchedMessageArchivingResultsController
{
    [self getMessagesFromFetchedRequest];
}



#pragma mark - Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%d",[self.chatArray count]);
    return [self.chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]) {
		return 40;
	}else {
		UIView *chatView = [[self.chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
		return chatView.frame.size.height+10;
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CommentCellIdentifier = @"CommentCell";
	ChartCell *cell = (ChartCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier forIndexPath:indexPath];
	
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell prepareForReuse];
        
	
    
    if (cell.kContentView.subviews.count != 0) {
        for (id obj in cell.kContentView.subviews) {
            [obj removeFromSuperview];
            
        }
    }
    

		// Set up the cell...
		NSDictionary *chatInfo = [self.chatArray objectAtIndex:[indexPath row]];
		UIView *chatView = [chatInfo objectForKey:@"view"];
    
		[cell.kContentView addSubview:chatView];

    return cell;
}
#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.enterTextField resignFirstResponder];
}





#pragma mark - TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(textField == self.enterTextField)
	{
        //		[self moveViewUp];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.enterTextField resignFirstResponder];
    return YES;
}

#pragma mark - MJRefresh Delegate -进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) {
        
        
        // 2秒后刷新表格
        [self performSelector:@selector(mjReloadChartList) withObject:nil afterDelay:1];
    }
    
    
}

-(void)mjReloadChartList
{
    NSInteger currentIndex = self.chatArray.count;
    _isMJRefreshing = YES;
    [XMPPManager instence].pageCount += 20;
    [self getMessagesFromFetchedRequest];
    
    
    if (currentIndex > 5) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]  - currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }


    [_header endRefreshing];
}

#pragma mark - Responding to keyboard events
- (void)mkeyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height andDuration:animationDuration];
}


- (void)mkeyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0 andDuration:animationDuration];
}

-(void) autoMovekeyBoard: (float)h andDuration:(NSTimeInterval)animationDuration{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
	animation.duration = animationDuration;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionFade;
	animation.subtype = kCATransitionFromTop;

    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
    [toolbar.layer addAnimation:animation forKey:@"chart"];
    
    if (IS_IPHONE5) {
        toolbar.frame = CGRectMake(0.0f, (float)(ScreenHeight-h-24.0), 320.0f, 44.0f);
    }else{
        toolbar.frame = CGRectMake(0.0f, (float)(ScreenHeight-h-42.0), 320.0f, 44.0f);
    }
    //	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	self.tableView.frame = CGRectMake(0, 64, 320.0f,(float)(ScreenHeight-h-95.0));
    if (self.chatArray.count > 5) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
    }
}







#pragma mark -  生成泡泡UIView
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
	// build single chat bubble cell with given text
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    returnView.backgroundColor = [UIColor clearColor];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    //气泡
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    //头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = 5;
    headImageView.layer.masksToBounds = YES;
    
    if(fromSelf){
        [headImageView setImage:selfHeadImage];
        returnView.frame= CGRectMake(10.0f, 18.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(0.0f, 14.0f, returnView.frame.size.width+28.0f, returnView.frame.size.height+28.0f );
        cellView.frame = CGRectMake(265.0f-bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width+50.0f, bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(bubbleImageView.frame.size.width, cellView.frame.size.height-50.0f, 45.0f, 45.0f);
    }
	else{
        [headImageView setImage:friendHeadImage];
        returnView.frame= CGRectMake(66.0f, 18.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(50.0f, 14.0f, returnView.frame.size.width+28.0f, returnView.frame.size.height+28.0f);
		cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(7.0f, cellView.frame.size.height-50.0f, 45.0f, 45.0f);
    }
    
    
    
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [cellView addSubview:returnView];
    
    
	return cellView;
    
}


#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

//图文混排
-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}


- (IBAction)didClickSendButton:(UIBarButtonItem *)sender {
    
    NSString *messageStr = self.enterTextField.text;
    if ([messageStr isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败！" message:@"发送的内容不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }else
    {
        [[XMPPManager instence]sendMessage:messageStr];
        
        NSLog(@"From: You, Message: %@", self.enterTextField.text);
        if (self.chatArray.count > 5) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
        }
    }
    
    
    self.enterTextField.text = @"";

    
}

- (IBAction)didClcikRecord:(UIBarButtonItem *)sender {
}





- (IBAction)didClickBack:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

#pragma mark - VoiceRecorderBaseVC Delegate Methods
//录音完成回调，返回文件路径和文件名
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)thepath fileName:(NSString*)_fileName{

    NSLog(@"%@",thepath);
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:thepath]) {
        NSData *data = [NSData dataWithContentsOfFile:thepath];
        NSString *base64 = [data base64EncodedString];
        [self sendAudio:base64 withName:_fileName];
    }
}
-(void)sendAudio:(NSString *)base64String withName:(NSString *)audioName{
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"base64"];
    [soundString appendString:base64String];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.toSomeOne];
    NSLog(@"%@",self.toSomeOne);
    [message addBody:soundString];
    [[[XMPPManager instence] xmppStream] sendElement:message];
}

#pragma mark - Private Methods
//创建sounds文件夹
-(NSString *)soundsAtDocumentPath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents lastObject];
    soundsPath = [[NSString alloc]initWithString:[documentsPath stringByAppendingString:@"/sounds"]];

    if (![[NSFileManager defaultManager]fileExistsAtPath:soundsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:soundsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return soundsPath;
}

- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init] ;
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    //    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    NSDate *date = [NSDate date];
    NSString *str = [soundsPath stringByAppendingFormat:@"/%@.pcm",[date description]];
    path = [str copy];
    NSURL *url = [NSURL fileURLWithPath:str];
    urlPlay = url;
    
    NSError *error;
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    [avSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [avSession setActive:YES error:nil];
    
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
//    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"err %@",[error description]);
}


-(void)audio_PCMtoMP3
{
    
    NSString *mp3FileName = @"test.mp3";
    
    mp3FilePath = [soundsPath stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([path cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        NSLog(@"MP3生成成功: %@",mp3FilePath);
        [self VoiceRecorderBaseVCRecordFinish:mp3FilePath fileName:mp3FileName];
        
    }
    
}

//开始录音
- (IBAction)beginAudio:(id)sender
{
    self.tipLabel.hidden = NO;
    
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    
    //设置定时检测
//    timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:nil userInfo:nil repeats:YES];
    NSLog(@"开始录音");
}
//完成录音
- (IBAction)endAudio:(id)sender
{
    self.tipLabel.hidden = YES;
    
    [recorder stop];
    [timer invalidate];
    [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    
    return;
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        NSDate *date = [NSDate date];
        NSString *str = [soundsPath stringByAppendingFormat:@"/%@.pcm",[date description]];
        NSLog(@"省社让那个%@",str);
        NSURL *url = [NSURL fileURLWithPath:str];
        self.soundsData = [[NSData alloc] initWithContentsOfURL:url];
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent: str];
        NSLog(@"%@",filePath);
        [self.soundsData writeToFile:filePath atomically:YES];
        
    }else {
        //删除记录的文件
        [recorder deleteRecording];
        //删除存储的
    }
    
    NSLog(@"完成录音");
}
//取消录音
- (IBAction)cancelAudio:(id)sender
{
    self.tipLabel.hidden = YES;
    NSLog(@"取消录音");
    
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
}


//获得初始
-(void)getPopChartList:(NSArray *)allMessagesArr
{
    [self.chatArray removeAllObjects];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *aMessage in allMessagesArr) {
        if ([aMessage isOutgoing]) {
            UIView *chatView ;
            if ([aMessage.body hasPrefix:@"base64"]) {
                chatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 35)];
                BageCustonButton *button = [BageCustonButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(0, 0, 150, 35)];
                [button setTitle:@"语音" forState:UIControlStateNormal];
                [chatView addSubview:button];

                button.index = [fetchedMessageResultsController indexPathForObject:aMessage];
                [button addTarget:self action:@selector(didClcikPlay:) forControlEvents:UIControlEventTouchUpInside];
            }else
                chatView = [self bubbleView:[NSString stringWithFormat:@"%@",aMessage.body]from:YES];
            [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:aMessage.body, @"text", @"self", @"speaker", chatView, @"view", nil]];
        }else{
            UIView *chatView ;
            if ([aMessage.body hasPrefix:@"base64"]) {
                chatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 35)];
                BageCustonButton *button = [BageCustonButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(0, 0, 150, 35)];
                [button setTitle:@"语音" forState:UIControlStateNormal];
                [chatView addSubview:button];

                button.index = [fetchedMessageResultsController indexPathForObject:aMessage];
                [button addTarget:self action:@selector(didClcikPlay:) forControlEvents:UIControlEventTouchUpInside];
            }else
                chatView = [self bubbleView:[NSString stringWithFormat:@"%@",  aMessage.body]from:NO];
            [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:aMessage.body, @"text", @"other", @"speaker", chatView, @"view", nil]];
        }
    }
    [self.tableView reloadData];
    if (_isMJRefreshing) {
         _isMJRefreshing = !_isMJRefreshing;
    }else
        [self reloadChartListWithAnimation];
    
   
}

-(void)didClcikPlay:(BageCustonButton *)button
{
    XMPPMessageArchiving_Message_CoreDataObject *aMessage = [fetchedMessageResultsController objectAtIndexPath:button.index];
    NSString *soundStr = [aMessage.body substringFromIndex:6];
    NSData *soundData = [soundStr base64DecodedData];
    
    NSString *soundPath = [[self soundsAtDocumentPath] stringByAppendingString:@"/receieved.mp3"];
    if ([soundData writeToFile:soundPath atomically:YES]) {
        NSLog(@"写入成功");
    }
    
    if (self.avPlay.playing) {
        [self.avPlay stop];
        return;
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:soundStr] error:nil];

    self.avPlay = player;
    [self.avPlay play];
    
}


-(void)reloadChartListWithAnimation
{
    NSInteger currentIndex = self.chatArray.count;
    
    
    if (currentIndex > 5) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:YES];
    }
    [_header endRefreshing];

}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
