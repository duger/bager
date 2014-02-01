//
//  BageCoreDataManager.m
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "BageCoreDataManager.h"
@interface BageCoreDataManager ()
-(NSManagedObjectContext *)context;
-(NSPersistentStoreCoordinator *)coordinator;
-(NSManagedObjectModel *)modle;

@end

@implementation BageCoreDataManager
{
    NSManagedObjectContext                  *context;
    NSPersistentStoreCoordinator            *coordinator;
    NSManagedObjectModel                    *model;
    
}
static BageCoreDataManager *instance = nil;
+(BageCoreDataManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BageCoreDataManager alloc]init];
    });

    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self context];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - 管理器 - 连接器 - 模型器
-(NSManagedObjectContext *)context
{
    if (context != nil ) {
        return context;
    }
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:[self coordinator]];
    return context;
}

-(NSPersistentStoreCoordinator *)coordinator
{
    if (coordinator != nil ) {
        return coordinator;
    }
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self modle]];
    
    NSURL *url = [NSURL fileURLWithPath:[self getPath]];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setValue:@(YES) forKey:NSAddedPersistentStoresKey];
    NSError * error = nil;
    //删除日志
    [options setObject:@{@"journal_mode":@"DELETE"} forKey:NSSQLitePragmasOption];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
    if (error) {
        //如果连接错误
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据库连接失败" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Back",error,nil];
        [alertView show];
    }
    return coordinator;
}

-(NSManagedObjectModel *)modle
{
    if (model != nil ) {
        return model;
    }
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    return model;
}

//文件路径
-(NSString *)getPath
{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [documentPath stringByAppendingFormat:@"/Share.sqlite"];
    return filePath;
}

- (void)save
{
    if ([[self context]hasChanges]) {
        [[self context]save:nil];
    }
}

//添加
- (Match *)addMatch
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Match" inManagedObjectContext:[self context]];
    Match *match = [[Match alloc] initWithEntity:entity insertIntoManagedObjectContext:[self context]];
    return match;
}
- (Topic *)addTopic
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Topic" inManagedObjectContext:[self context]];
    Topic *topic = [[Topic alloc] initWithEntity:entity insertIntoManagedObjectContext:[self context]];
    return topic;
}
- (MemberPoints *)addMemberPoints
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MemberPoints" inManagedObjectContext:[self context]];
    MemberPoints *memberPoints = [[MemberPoints alloc] initWithEntity:entity insertIntoManagedObjectContext:[self context]];
    return memberPoints;
}
- (Members *)addMembers
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Members" inManagedObjectContext:[self context]];
    Members *members = [[Members alloc] initWithEntity:entity insertIntoManagedObjectContext:[self context]];
    return members;
}
//删除
- (void)deleteMatch:(Match *)match
{
    [[self context] deleteObject:match];
}
- (void)deleteTopic:(Topic *)topic
{
    [[self context] deleteObject:topic];
}
- (void)deleteMemberPoints:(MemberPoints *)memberPoints
{
    [[self context] deleteObject:memberPoints];
}
- (void)deleteMember:(Members *)members
{
    [[self context] deleteObject:members];
}
//查询
- (NSArray *)allMatch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    NSArray *matchArray = [[self context] executeFetchRequest:fetchRequest error:nil];
    return matchArray;
}
- (NSArray *)allTopic
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Topic"];
    NSArray *topicArray = [[self context] executeFetchRequest:fetchRequest error:nil];
    return topicArray;
}
- (NSArray *)allMemberPoints
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MemberPoints"];
    NSArray *memberPointsArray = [[self context] executeFetchRequest:fetchRequest error:nil];
    return memberPointsArray;
}
- (NSArray *)allMembers
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Members"];
    NSArray *membersArray = [[self context] executeFetchRequest:fetchRequest error:nil];
    return membersArray;
}
- (NSArray *)allMemberPointsFromMembers:(Members *)members
{
    NSArray *memberPointsArray = [members.pointList allObjects];
    return memberPointsArray;
}
@end
