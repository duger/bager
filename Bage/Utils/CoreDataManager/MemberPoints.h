//
//  MemberPoints.h
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Members;

@interface MemberPoints : NSManagedObject

@property (nonatomic, retain) NSString * m_jid;
@property (nonatomic, retain) NSNumber * mp_lastTime;
@property (nonatomic, retain) NSNumber * mp_experience;
@property (nonatomic, retain) NSDate * mp_date;
@property (nonatomic, retain) NSNumber * mp_star;
@property (nonatomic, retain) Members *memberInfo;

@end
