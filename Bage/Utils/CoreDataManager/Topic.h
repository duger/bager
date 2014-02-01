//
//  Topic.h
//  Bage
//
//  Created by FAVORVENUS on 14-1-15.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * t_content;
@property (nonatomic, retain) NSString * t_created_date;
@property (nonatomic, retain) NSString * t_id;
@property (nonatomic, retain) NSString * t_image_url;
@property (nonatomic, retain) NSString * t_name;
@property (nonatomic, retain) NSString * t_type;
@property (nonatomic, retain) NSString * t_writer;

@end
