//
//  SelectPlaceCell.h
//  BDSAAS
//
//  Created by ebadu on 2017/11/13.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"

@interface SelectPlaceCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *imageV;
@property (nonatomic, strong) UILabel       *contentLabel;
@property (nonatomic, strong) AreaModel     *model;

@end
