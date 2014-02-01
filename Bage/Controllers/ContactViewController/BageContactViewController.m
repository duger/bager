//
//  BageContactViewController.m
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BageContactViewController.h"
#import "FriendsPersonalCell.h"
#import "FriendsTeamCell.h"
#import "ChooseAddTypeViewController.h"
#import "BagePersonChatViewController.h"
#import "ChartViewController.h"

#define kContactPersonSegmentIndex 0
#define kContactTeamSegmentIndex 1

@interface BageContactViewController ()
{
    NSFetchedResultsController *_fetchedResultsController;
}

@end

@implementation BageContactViewController
{
    NSMutableArray * contactPersonList;
    NSMutableArray * contactTeamList;
    UISegmentedControl * displaySeg;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"联系人";

        contactPersonList = [[NSMutableArray alloc]init];
        contactTeamList = [[NSMutableArray alloc]init];
    }

    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getFriendList];
    [self getTeamList];
    [self showTabBar];
    
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _fetchedResultsController = [[XMPPManager instence]XMPPRosterFetchedResultsController];
    [[XMPPManager instence]setDelegate:self];
    
    //添加观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToChart:) name:kLetsChart object:nil];
    
    //添加segment
    displaySeg = [[UISegmentedControl alloc]initWithItems:@[@"联系人",@"小组"]];
    displaySeg.frame = CGRectMake(0, 0, 140, 30);
    [displaySeg addTarget:self action:@selector(didClickChangeDisplayType:) forControlEvents:UIControlEventValueChanged];
    displaySeg.selectedSegmentIndex = 0;
    self.navigationItem.titleView = displaySeg;
    [displaySeg release];
    
    self.friendlistTableView.delegate = self;
    self.friendlistTableView.dataSource = self;

    
    UIBarButtonItem * addBuddyBtn = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(didAddBuddyAction:)];
    self.navigationItem.rightBarButtonItem = addBuddyBtn;
    [self setBackBarButtonItemWithTitle:@"返回"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_friendlistTableView release];
//    [_friendlistTableView release];
    [super dealloc];
}
- (void)didClickChangeDisplayType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case kContactPersonSegmentIndex:
        {
            //请求联系人列表数据，并刷新table
            [self.friendlistTableView reloadData];
            break;
        }
        case kContactTeamSegmentIndex:
        {
            //请求小组列表数据，并刷新table
            
            [self.friendlistTableView reloadData];
            break;
        }
        default:
            break;
    }
}
#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%d",[[_fetchedResultsController sections]count]);
    return [[_fetchedResultsController sections]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [_fetchedResultsController sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return @"在线";
			case 1  : return @"离开";
			default : return @"离线";
		}
	}
	
	return @"";
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (displaySeg.selectedSegmentIndex) {
        case kContactPersonSegmentIndex:
        {
            return 90;//contactPersonList.count;
            break;
        }
        case kContactTeamSegmentIndex:
        {
            return 200;//contactTeamList.count;
            break;
        }
        default:
            break;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (displaySeg.selectedSegmentIndex) {
        case kContactPersonSegmentIndex:
        {
            NSArray *sections = [_fetchedResultsController sections];
            NSLog(@"sectons %ld",[sections count]);
            
            if (section < [sections count])
            {
                id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
                
                return sectionInfo.numberOfObjects;
                
            }
          
            //return contactPersonList.count;
            break;
        }
        case kContactTeamSegmentIndex:
        {
            return 12;
            //return contactTeamList.count;//contactTeamList.count;
            break;
        }
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (displaySeg.selectedSegmentIndex) {
        case kContactPersonSegmentIndex:
        {
            //刷新联系人列表数据
            static NSString *cellName=@"FriendsPersonalCell";
            FriendsPersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if(cell==nil){
                cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendsPersonalCell" owner:self options:nil]lastObject];
            }
            XMPPUserCoreDataStorageObject *user = [_fetchedResultsController objectAtIndexPath:indexPath];
            NSString *name = [user displayName];
            if ( [name isEqualToString:@"null"]) {
                name = [user nickname];
            }
            if ([name isEqualToString:@"null"]) {
                name = [user jidStr];
            }
            cell.userNameLabel.text = name;
            cell.detailLabel.text = [[user primaryResource]status];
            cell.headerImageView.image = [self configurePhotoForCell:user];
            //[cell setPersonAtrributeWithBuddyItem:[contactPersonList objectAtIndex:indexPath.row]];
            return  cell;
            
        }
        case kContactTeamSegmentIndex:
        {
            //刷新小组列表数据
            static NSString *cellName=@"FriendsTeamCell";
            FriendsTeamCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
            if(cell==nil){
                cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendsTeamCell" owner:self options:nil]lastObject];
            }
            cell.backgroundColor = [UIColor cyanColor];
            return  cell;
        }
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (displaySeg.selectedSegmentIndex) {
        case kContactPersonSegmentIndex:
        {
//            [self setHidesBottomBarWhenPushed:YES];
            //刷新联系人列表数据 //BagePersonChatViewController.h
            BagePersonChatViewController * personChatVC = [[BagePersonChatViewController alloc]init];
            BuddyItem * buddy =[contactPersonList objectAtIndex:indexPath.row];
            personChatVC.title = buddy.buddyName;
            [self.navigationController pushViewController:personChatVC animated:YES];
            
        }
        case kContactTeamSegmentIndex:
        {
            //刷新小组列表数据
        }
        default:
            break;
    }
}

#pragma mark - NOtificaton Methods
-(void)goToChart:(id)sender
{
    XMPPJID *jid = [XMPPJID jidWithString:[[sender userInfo]objectForKey:@"result"]];
    [XMPPManager instence].toSomeOne = jid;
//    BagePersonChatViewController *personChatVC = [[BagePersonChatViewController alloc]init];
    ChartViewController *chartVC = [[ChartViewController alloc]initWithNibName:@"ChartViewController" bundle:[NSBundle mainBundle]];
    chartVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chartVC animated:YES];
}

#pragma mark - private methods 
- (UIImage *)configurePhotoForCell:(XMPPUserCoreDataStorageObject *)user
{
	// Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
	// We only need to ask the avatar module for a photo, if the roster doesn't have it.
	UIImage *headImage = [[UIImage alloc]init];
    
	if (user.photo != nil)
	{
		headImage = user.photo;
	}
	else
	{
		NSData *photoData = [[[XMPPManager instence] xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			headImage = [UIImage imageWithData:photoData];
		else
			headImage = [UIImage imageNamed:@"DefaultHead.png"];
	}
    return headImage;
}


-(void)getFriendList{
     
}
-(void) getTeamList{
    
}
-(void)presentBuddyListAction:(id) sender{
    
}
-(void)didAddBuddyAction:(id)sender{
    
    ChooseAddTypeViewController * chooseAddTypeVC = [[ChooseAddTypeViewController alloc]initWithNibName:@"ChooseAddTypeViewController" bundle:nil];
    [self.navigationController pushViewController:chooseAddTypeVC animated:YES];
    [chooseAddTypeVC release];
    
    
}

#pragma mark - XMPPManager Delegate -
-(void)xmppManager:(XMPPManager *)xmppManager didReceiveNewPresenceWithBuddyItem:(BuddyItem *)buddyItem{
    [contactPersonList addObject:buddyItem];
    [self.friendlistTableView reloadData];
}
-(void)XMPPManager:(XMPPManager *)xmppManager didCreateRoomSuccessWithXMPPRoom:(XMPPRoom *)xmppRoom{
    [contactTeamList addObject:xmppRoom];
    [self.friendlistTableView reloadData];
}

-(void)controllerDidChangedWithFetchedResult:(NSFetchedResultsController *)fetchedResultsController
{
    [self.friendlistTableView reloadData];
}
    
@end
