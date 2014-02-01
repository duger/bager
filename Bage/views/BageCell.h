//
//  BageCell.h
//  Bage
//
//  Created by Lori on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BageCellType) {
    BageCellTypeWithAcceroryView = 0,
    BageCellTypeWithRankingList
};

@interface BageCell : UITableViewCell
{

}

@property(nonatomic,retain)UIView           *aView;

@property(nonatomic,retain)UILabel          *aRank;
@property(nonatomic,retain)UIImageView      *aImageView;
@property(nonatomic,retain)UILabel          *aID;
@property(nonatomic,retain)UILabel          *aScore;



//指定初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BageCellType)type;
@end
