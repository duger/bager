//  DetailViewController.m
//  Bage
//  Created by Lori on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import "DetailViewController.h"
#import "DataTableView.h"
#import "LineChartViewController.h"
#import "XMPPManager.h"
#import "XMPP.h"
#import "XMPPvCardTemp.h"
#define DELETE_PORTRAIT_URL @"http://124.205.147.26/student/class_10/team_six/resource/delete_portrait.php?file_path=%@.png"
#define kManagerUpload_URL @"http://124.205.147.26/student/class_10/team_six/zgq_upload.php"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    UIImagePickerController *imagePickerController;
    dispatch_queue_t queue;
    NSString *boundary;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    boundary = [[NSString stringWithFormat:@"---------%d---------",(int)[[NSDate date] timeIntervalSince1970]] retain];
    // Do any additional setup after loading the view from its nib.
    NSString *jid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
//    XMPPJID *userJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,kDOMAIN]];
    XMPPvCardTemp *cardTemp = [[[XMPPManager instence] xmppvCardTempModule] myvCardTemp];
    _photoImageView.backgroundColor=[UIColor cyanColor];
    _photoImageView.userInteractionEnabled = YES;
    NSString *portraitUrl = @"http://124.205.147.26/student/class_10/team_six/resource/wangfu.png";
    NSURL *url = [NSURL URLWithString:portraitUrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        _photoImageView.image = image;
    }];
//    _photoImageView.image = [[XMPPManager instence] getOneselfHeadImage:userJID];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didChangePortrait)];
    [_photoImageView addGestureRecognizer:tap];
    [tap release];
    _nicknameField.text = cardTemp.nickname;
    _idfield.text = jid;
    _sexfield.text = @"M";
    _gradeField.text = @"10";
    _addressField.text = @"北京 海淀";
    _signatureFiled.text = @"-_-! >_<! =_=!";
    [self.activeRecordButton setTitle:@"活动记录" forState:UIControlStateNormal];
    [self.studyProgressButton setTitle:@"学习进程" forState:UIControlStateNormal];
    [self.scheduleButton setTitle:@"ta的日程" forState:UIControlStateNormal];
    [self.sendMessageOrAddFriendButton setTitle:@"发消息/加好友" forState:UIControlStateNormal];
    [self.applyforPartnerButton setTitle:@"申请partner" forState:UIControlStateNormal];
    //如果是查看自己的资料
    if (self.isSelf) {
        [self.activeRecordButton removeFromSuperview];
        [self.studyProgressButton removeFromSuperview];
        [self.scheduleButton removeFromSuperview];
        [self.sendMessageOrAddFriendButton removeFromSuperview];
        [self.applyforPartnerButton removeFromSuperview];
        
        
        
        
        
        NSArray *array1 = @[@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20];
        NSArray *array2 = @[@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30];
        NSArray *array3 = @[@40,@90,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:array1,array2,array3, nil];
        
        
        
        
        
        DataTableView *dataTableView = [[DataTableView alloc] initWithFrame:CGRectMake(0, 0, 150, 320) dataArray:array] ;
        dataTableView.backgroundColor=[UIColor cyanColor];
        [dataTableView setFrame:CGRectMake(0, 580, 320 ,220+50-12)];
        [self.view addSubview:dataTableView];
        [dataTableView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_photoImageView release];
    [_nameLabel release];
    [_sexLabel release];
    [_IDLabel release];
    [_signatureLabel release];
    [_areaLabel release];
    [_activeRecordButton release];
    [_studyProgressButton release];
    [_scheduleButton release];
    [_sendMessageOrAddFriendButton release];
    [_applyforPartnerButton release];
    [_nicknameField release];
    [_sexfield release];
    [_idfield release];
    [_gradeField release];
    [_addressField release];
    [_signatureFiled release];
    [super dealloc];
}

- (void)didChangePortrait
{
    UIActionSheet *actionSheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        actionSheet.tag = 1;
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
        actionSheet.tag = 1;
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        NSInteger sourceType = 0;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    break;
            }
        }else{
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else{
                return;
            }
        }
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
            ;
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == imagePickerController) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _photoImageView.image = image;
        [self webChangePortrait:image];
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)webChangePortrait:(UIImage *)image
{
    
    NSString *jid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *urlString = [NSString stringWithFormat:DELETE_PORTRAIT_URL,jid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",content);
        if ([content isEqualToString:@"Deleted success"]) {
            dispatch_async(queue, ^{
                [self UploadPortrait:image];
            });
        }else{
            NSLog(@"无法上传头像");
        }
    }];
}

- (void)UploadPortrait:(UIImage *)image
{
    NSURL *url = [NSURL URLWithString:kManagerUpload_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //文件格式
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSData *body = [self portraitBody:image];
    [request setHTTPBody:body];
    
    //异步实现上传文件
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"头像上传成功\n%@",content);
    }];
    [[NSRunLoop currentRunLoop] run];
}

- (NSData *)portraitBody:(UIImage *)image
{
    NSMutableData *body = [NSMutableData data];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *jid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    NSString *content_Disposition_image = [NSString stringWithFormat:@"Content-Disposition: attachment; name=\"imagefile\"; filename=\"%@.png\"\r\n",jid];
    
    //发送body内的内容类型,流体,不用变
    NSString *content_Type = @"Content-Type: application/octet-stream\r\n\r\n";
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //设置参数形式
    [body appendData:[content_Disposition_image dataUsingEncoding:NSUTF8StringEncoding]];
    //设置参数类型
    [body appendData:[content_Type dataUsingEncoding:NSUTF8StringEncoding]];
    //添加真实数据
    [body appendData:imageData];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (IBAction)didClickCheckActiveRecord:(UIButton *)sender {
   

}

- (IBAction)didClickCheckStudyProgress:(UIButton *)sender
{
    LineChartViewController *lineChartViewController = [[LineChartViewController alloc] init];
    [self.navigationController pushViewController:lineChartViewController animated:YES];
}

- (IBAction)didClickCheckSchedule:(UIButton *)sender {
}

- (IBAction)didClickSendMessageOrAddFriend:(UIButton *)sender {
}

- (IBAction)didClickApplyforPartner:(UIButton *)sender {
}

@end