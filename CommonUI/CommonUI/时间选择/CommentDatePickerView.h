//
//  CommentDatePickerView.h
//  BDSAAS
//
//  Created by ebadu on 2017/11/9.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateCompleteBlock)(NSDate *date);
typedef NS_ENUM(NSInteger ,ComDatePickType) {
    
    ComDatePickTypeYearMonthDayHourMinute = 1,
    ComDatePickTypeYearMonthDay = 2,
    ComDatePickTypeYearMonth    = 3
    
};
@interface CommentDatePickerView : UIView

///限制最大时间（没有设置默认9999）
@property (nonatomic, retain) NSDate *maxLimitDate;
//限制最小时间（没有设置默认0）
@property (nonatomic, retain) NSDate *minLimitDate;

///当前时间
@property (nonatomic, retain) NSDate *currentDate;

///创建选择器
- (instancetype)initWithComDatePickType:(ComDatePickType )comdatepickType WithBlock:(DateCompleteBlock)block;

///展示选择器
- (void)show;

@end
