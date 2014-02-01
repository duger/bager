//
//  Members.h
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MemberPoints;

@interface Members : NSManagedObject

@property (nonatomic, retain) NSString * m_Jid;
@property (nonatomic, retain) NSNumber * m_Lv;
@property (nonatomic, retain) NSNumber * m_stars;
@property (nonatomic, retain) NSSet *pointList;
@end

@interface Members (CoreDataGeneratedAccessors)

- (void)addPointListObject:(MemberPoints *)value;
- (void)removePointListObject:(MemberPoints *)value;
- (void)addPointList:(NSSet *)values;
- (void)removePointList:(NSSet *)values;

@end
