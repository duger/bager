//
//  BageCoreDataManager.h
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MemberPoints.h"
#import "Members.h"
#import "Match.h"
#import "Topic.h"

@interface BageCoreDataManager : NSObject
+(BageCoreDataManager *)defaultManager;
//添加
- (Match *)addMatch;
- (Topic *)addTopic;
- (MemberPoints *)addMemberPoints;
- (Members *)addMembers;
//删除
- (void)deleteMatch:(Match *)match;
- (void)deleteTopic:(Topic *)topic;
- (void)deleteMemberPoints:(MemberPoints *)memberPoints;
- (void)deleteMember:(Members *)members;
//查询
- (NSArray *)allMatch;
- (NSArray *)allTopic;
- (NSArray *)allMemberPoints;
- (NSArray *)allMembers;
- (NSArray *)allMemberPointsFromMembers:(Members *)members;
//保存
- (void)save;
@end
