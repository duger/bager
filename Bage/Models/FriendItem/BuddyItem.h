//
//  BuddyItem.h
//  Bage
//
//  Created by lixinda on 13-12-28.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPPresence.h"

@interface BuddyItem : NSObject

@property (nonatomic,copy) NSString * buddyName;
@property (nonatomic,copy) NSString * buddyStatus;
@property (nonatomic,copy) NSString * buddyResource;
@property (nonatomic,retain) UIImage * headerImage;

-(id) initWithPresence:(XMPPPresence *)presence;
-(id) initWithBuddyDict:(NSDictionary * ) dict;
@end
