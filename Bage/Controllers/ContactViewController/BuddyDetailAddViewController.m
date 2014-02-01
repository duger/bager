//
//  BuddyDetailAddViewController.m
//  Bage
//
//  Created by lixinda on 13-12-31.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BuddyDetailAddViewController.h"
#import "XMPPManager.h"


@interface BuddyDetailAddViewController ()

@end

@implementation BuddyDetailAddViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.headerImageView.image = self.buddyItem.headerImage;
    self.userNameLabel.text = self.buddyItem.buddyName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickAddBuddyAction:(id)sender {
    NSString * tempString = nil;
    if (![self.buddyItem.buddyName hasSuffix:[NSString stringWithFormat:@"@%@",kXMPPHostName]]) {
        tempString = [NSString stringWithFormat:@"%@@%@",self.buddyItem.buddyName,kXMPPHostName];
    }else{
        tempString = self.buddyItem.buddyName;
    }
    [[[XMPPManager instence]xmppRoster]addUser:[XMPPJID jidWithString:tempString] withNickname:nil];
    
}
- (void)dealloc {
    [_headerImageView release];
    [_userNameLabel release];
    [super dealloc];
}
@end
