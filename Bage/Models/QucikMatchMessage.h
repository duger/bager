//
//  QucikMatchMessage.h
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "Require.h"

@interface QucikMatchMessage : Require

@property (nonatomic ,assign) NSInteger sex;
@property (nonatomic ,assign) NSInteger topicType;
@property (nonatomic ,assign) NSInteger topicId;
@property (nonatomic ,assign) NSTimeInterval runTime;
@property (nonatomic ,assign) NSInteger partnerSpokenLV;
@property (nonatomic ,assign) NSInteger language;

@end
