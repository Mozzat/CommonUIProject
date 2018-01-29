//
//  CommentDatePickerView.m
//  BDSAAS
//
//  Created by ebadu on 2017/11/9.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import "CommentDatePickerView.h"
#import "NSDate+Extension.h"
#import "Header.h"
#import "UIView+Common.h"
///默认最大时间9999年
#define MAXYEAR 9999
///最小是当前时间
#define MINYEAR 0

typedef void(^DoneClink)(NSDate *date);
@interface CommentDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSMutableArray *_yearArr;  //年
    NSMutableArray *_monthArr; //月
    NSMutableArray *_dayArr;   //日
    NSMutableArray *_hourArr;  //时
    NSMutableArray *_minArr;   //分
    NSString       *_dateFormatter;
    //记录位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
    
}

@property (nonatomic, strong)  UIView           *bottomView;
@property (nonatomic, strong)  UIView           *bottomTopView;
@property (nonatomic, strong)  UIPickerView     *pickView1;
@property (nonatomic, strong)  UIPickerView     *pickView2;

///滚到指定日期_startDate
@property (nonatomic, retain)  NSDate           *scrollToDate;
@property (nonatomic, retain)  NSDate           *startDate;
@property (nonatomic, assign)  ComDatePickType  comDatePickType;
@property (nonatomic, copy)    DoneClink        doneClink;

@end

@implementation CommentDatePickerView

- (instancetype)initWithComDatePickType:(ComDatePickType )comdatepickType WithBlock:(DateCompleteBlock)block{
    
    if (self = [super init]) {
        
        self.backgroundColor = defaultMaskViewColor();
        
        self.comDatePickType = comdatepickType;
        
        self.frame = CGRectMake(0, 0, SCREENWIDTH(), SCREENHEIGHT());
        
        [self addSubview:self.bottomView];
        
        ///基本配置
        [self baseConfig];
        
        if (block) {
            self.doneClink = ^(NSDate *date) {
              
                block(date);
                
            };
        }
        
    }
    return self;
}



- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT() - 250, SCREENWIDTH(), 250)];
        _bottomView.backgroundColor = HexColor(@"ffffff");
        
        [_bottomView addSubview:self.bottomTopView];
        
        if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
            
            [_bottomView addSubview:self.pickView1];
            [_bottomView addSubview:self.pickView2];
            
        } else if (self.comDatePickType == ComDatePickTypeYearMonthDay) {
            
            [_bottomView addSubview:self.pickView1];
            
        } else if (self.comDatePickType == ComDatePickTypeYearMonth) {
            
            [_bottomView addSubview:self.pickView1];
            [_bottomView addSubview:self.pickView2];
            
        }
    
    }
    return _bottomView;
}

- (UIView *)bottomTopView{
    
    if (!_bottomTopView) {
        
        _bottomTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH(), 40)];
        _bottomTopView.backgroundColor = DefaultBackgroundColor();
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 100, 40)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:HexColor(@"777777") forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = UIFontSize(15);
        cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomTopView addSubview:cancleBtn];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH() -  120, 0, 100, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:DefaultBlueColor() forState:UIControlStateNormal];
        sureBtn.titleLabel.font = UIFontSize(15);
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_bottomTopView addSubview:sureBtn];
        
    }
    return _bottomTopView;
}

- (UIPickerView *)pickView1{
    
    if (!_pickView1) {
        
        CGFloat width = SCREENWIDTH();
        if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
            width = 2 * (SCREENWIDTH() - 50) /3;
            
        } else if (self.comDatePickType == ComDatePickTypeYearMonth) {
            width = SCREENWIDTH()/2.0;
            
        }
        
        _pickView1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.bottomTopView.bottom, width, self.bottomView.height - self.bottomTopView.height)];
        
        _pickView1.delegate = self;
        _pickView1.dataSource = self;
        
    }
    return _pickView1;
}

- (UIPickerView *)pickView2{
    
    if (!_pickView2) {
        
        CGFloat width = SCREENWIDTH();
        CGFloat x = 2 * (SCREENWIDTH() - 50)/3.0 + 30;
        if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
            width = SCREENWIDTH()/3;
            
        } else if (self.comDatePickType == ComDatePickTypeYearMonth) {
            width = SCREENWIDTH()/2.0;
            x = SCREENWIDTH()/2.0;
            
        }
        
        _pickView2 = [[UIPickerView alloc]initWithFrame:CGRectMake(x, self.bottomTopView.bottom, width, self.bottomView.height - self.bottomTopView.height)];
        
        _pickView2.delegate = self;
        _pickView2.dataSource = self;
        
    }
    return _pickView2;
}

#pragma mark---- 私有的方法
///取消按钮点击时间
- (void)cancleBtnAction{
    
    [self dismiss];
    
}

///确定按钮点击时间
- (void)sureBtnAction{
    
    self.startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    
    if (self.doneClink) {
        self.doneClink(self.startDate);
    }
    [self dismiss];
    
}

///初始化数组
- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}


///展示
#pragma mark - Action
-(void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (self.currentDate) {
        self.scrollToDate = self.currentDate;
        [self getNowDate:self.currentDate animated:NO];
    }
//    
//    [UIView animateWithDuration:.3 animations:^{
//        self.bottomConstraint.constant = 10;
//        self.backgroundColor = RGBA(0, 0, 0, 0.4);
//        [self layoutIfNeeded];
//    }];
}

///隐藏
-(void)dismiss {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.bottomView.y = SCREENHEIGHT();
        
    } completion:^(BOOL finished) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        
    }];
    

}


- (void)baseConfig{
    
    if (!self.scrollToDate) {
        
        self.scrollToDate = [NSDate date];
        
    }
    
    switch (self.comDatePickType) {
        case ComDatePickTypeYearMonthDayHourMinute:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
        case ComDatePickTypeYearMonthDay:
            _dateFormatter = @"yyyy-MM-dd";
            break;
        case ComDatePickTypeYearMonth:
            _dateFormatter = @"yyyy-MM";
            break;
        default:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
    }
    
    _yearArr = [self setArray:_yearArr];
    _monthArr = [self setArray:_monthArr];
    _dayArr = [self setArray:_dayArr];
    _hourArr = [self setArray:_hourArr];
    _minArr = [self setArray:_minArr];
    
    for (NSInteger index = 0; index < 60; index ++) {
        
        if (index < 12) { ///设置月
            
            NSString *monthStr = [NSString stringWithFormat:@"%02ld月",index + 1];
            [_monthArr addObject:monthStr];
            
        }
        
        if (index < 24) { ///设置小时
            NSString *hourStr = [NSString stringWithFormat:@"%02ld时",index];
            [_hourArr addObject:hourStr];
            
        }
        
        ///设置分
        NSString *minStr = [NSString stringWithFormat:@"%02ld分",index];
        [_minArr addObject:minStr];
        
    }
    
    ///设置年份
    for (NSInteger index = MINYEAR; index < MAXYEAR; index ++) {
        
        NSString *yearStr = [NSString stringWithFormat:@"%02ld年",index + 1];
        [_yearArr addObject:yearStr];
        
    }

    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"9999-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"0000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self daysfromYear:date.year andMonth:date.month];
    
    _yearIndex = date.year - MINYEAR - 1;
    _monthIndex = date.month-1;
    _dayIndex = date.day-1;
    _hourIndex = date.hour;
    _minuteIndex = date.minute;
    
    //循环滚动时需要用到
//    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute)
        indexArray = @[@[@(_yearIndex),@(_monthIndex),@(_dayIndex)],@[@(_hourIndex),@(_minuteIndex)]];
    
    if (self.comDatePickType == ComDatePickTypeYearMonthDay)
        indexArray = @[@[@(_yearIndex),@(_monthIndex),@(_dayIndex)]];
    
    if (self.comDatePickType == ComDatePickTypeYearMonth)
        indexArray = @[@[@(_yearIndex)],@[@(_monthIndex)]];

    
    //    self.showYearView.text = _yearArray[yearIndex];
    
    [self.pickView1 reloadAllComponents];
    [self.pickView2 reloadAllComponents];
    
    for (NSInteger index = 0; index < indexArray.count; index ++) {
        
        NSArray *arr = indexArray[index];
        for (NSInteger j = 0; j < arr.count ; j ++) {
            
            if (index == 0) {
                [self.pickView1 selectRow:[arr[j] integerValue] inComponent:j animated:animated];
                
            } else {
                [self.pickView2 selectRow:[arr[j] integerValue] inComponent:j animated:animated];
                
            }
            
        }
        
    }

}

///通过年月求每月天数
- (NSInteger)daysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isRunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArr:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArr:30];
            return 30;
        }
        case 2:{
            if (isRunNian) {
                [self setdayArr:29];
                return 29;
            }else{
                [self setdayArr:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

///设置每月的天数数组
- (void)setdayArr:(NSInteger)num
{
    [_dayArr removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArr addObject:[NSString stringWithFormat:@"%02d日",i]];
    }
}


#pragma mark--- 设置最大最小年份
- (void)setMaxLimitDate:(NSDate *)maxLimitDate{
    
    maxLimitDate = maxLimitDate;
    
}

- (void)setMinLimitDate:(NSDate *)minLimitDate{
    
    _minLimitDate = minLimitDate;
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
    
}

#pragma mark----<UIPickerViewDelegate,UIPickerViewDataSource>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger section = 0;
    if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
        
        if (pickerView == self.pickView2) {
            section = 1;
            
        }
        
    } else if (self.comDatePickType == ComDatePickTypeYearMonth) {
        
        if (pickerView == self.pickView2) {
            section = 1;
        }
        
    }
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[section][component] integerValue];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    
    if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
        if (pickerView == self.pickView1) {
            return 3;
            
        } else {
            
            return 2;
        }
        
    } else if (self.comDatePickType == ComDatePickTypeYearMonthDay) {
        
        return 3;
        
    } else {
        
        return 1;
    }
    
}


-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArr.count;
    NSInteger monthNum = _monthArr.count;
    NSInteger dayNum = [self daysfromYear:[_yearArr[_yearIndex] integerValue] andMonth:[_monthArr[_monthIndex] integerValue]];
    NSInteger hourNum = _hourArr.count;
    NSInteger minuteNUm = _minArr.count;
    
    
    switch (self.comDatePickType) {
        case ComDatePickTypeYearMonthDayHourMinute:
            return @[@[@(yearNum),@(monthNum),@(dayNum)],@[@(hourNum),@(minuteNUm)]];
            break;
            
        case ComDatePickTypeYearMonthDay:
            return @[@[@(yearNum),@(monthNum),@(dayNum)]];
            break;
            
        case ComDatePickTypeYearMonth:
            return @[@[@(yearNum)],@[@(monthNum)]];
            break;
            
        default:
            return @[@[@(yearNum),@(monthNum),@(dayNum)],@[@(hourNum),@(minuteNUm)]];
            break;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = nil;
    customLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
    customLabel.textAlignment = NSTextAlignmentLeft;
    [customLabel setFont:[UIFont systemFontOfSize:15]];
    
    NSString *title;
    
    switch (self.comDatePickType) {
        case ComDatePickTypeYearMonthDayHourMinute:
            
            if (pickerView == self.pickView1) {
                
                if (component==0) {
                    title = _yearArr[row];
                }
                if (component==1) {
                    title = _monthArr[row];
                }
                if (component==2) {
                    title = _dayArr[row];
                }
                
            } else {
                
                if (component==0) {
                    title = _hourArr[row];
                }
                if (component==1) {
                    title = _minArr[row];
                }
                
            }
            
            break;
        case ComDatePickTypeYearMonthDay:
            if (component==0) {
                title = _yearArr[row];
            }
            if (component==1) {
                title = _monthArr[row];
            }
            if (component==2) {
                title = _dayArr[row];
            }
            break;
        case ComDatePickTypeYearMonth:
            
            if (pickerView == self.pickView1) {
                
                title = _yearArr[row];
                
            } else {
                
                title = _monthArr[row];
            }
            
            break;
            
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    customLabel.textColor = HexColor(@"777777");
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.comDatePickType == ComDatePickTypeYearMonthDayHourMinute) {
        
        if (pickerView == self.pickView1) {
            
            if (component == 0) {
                _yearIndex = row;
                
            } else if (component == 1) {
                _monthIndex = row;
                
            } else if (component == 2) {
                _dayIndex = row;
                
            }
            
            if (component == 0 || component == 1){
                [self daysfromYear:[_yearArr[_yearIndex] integerValue] andMonth:[_monthArr[_monthIndex] integerValue]];
                if (_dayArr.count-1<_dayIndex) {
                    _dayIndex = _dayArr.count-1;
                    
                }
                
            }
            
        } else {
            
            if (component == 0) {
                
                _hourIndex = row;
                
            } else if (component == 1) {
                
                _minuteIndex = row;
            }
            
        }
        
        
    } else if (self.comDatePickType == ComDatePickTypeYearMonthDay) {
        
        if (component == 0) {
            _yearIndex = row;
            
        } else if (component == 1) {
            _monthIndex = row;
            
        } else if (component == 2) {
            _dayIndex = row;
            
        }
        
        if (component == 0 || component == 1){
            [self daysfromYear:[_yearArr[_yearIndex] integerValue] andMonth:[_monthArr[_monthIndex] integerValue]];
            if (_dayArr.count-1<_dayIndex) {
                _dayIndex = _dayArr.count-1;
                
            }
            
        }
        
    } else if (self.comDatePickType == ComDatePickTypeYearMonth) {
        
        if (pickerView == self.pickView1) {
            _yearIndex = row;
            
        } else {
            _monthIndex = row;
            
        }
        
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArr[_yearIndex],_monthArr[_monthIndex],_dayArr[_dayIndex],_hourArr[_hourIndex],_minArr[_minuteIndex]];
    
    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy年-MM月-dd日 HH时:mm分"] dateWithFormatter:_dateFormatter];
    
//    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
//        self.scrollToDate = self.minLimitDate;
//        [self getNowDate:self.minLimitDate animated:YES];
//    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
//        self.scrollToDate = self.maxLimitDate;
//        [self getNowDate:self.maxLimitDate animated:YES];
//    }
    
    self.startDate = self.scrollToDate;
    
}


@end
