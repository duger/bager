//
//  Match.h
//  Bage
//
//  Created by FAVORVENUS on 14-1-15.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Match : NSManagedObject

@property (nonatomic, retain) NSString * mp_create_date;
@property (nonatomic, retain) NSString * mp_host_jid;
@property (nonatomic, retain) NSString * mp_id;
@property (nonatomic, retain) NSString * mp_partner_jid;
@property (nonatomic, retain) NSString * mp_runtime;
@property (nonatomic, retain) NSString * mp_topic_id;
@property (nonatomic, retain) NSString * mp_topic_type;

@end
