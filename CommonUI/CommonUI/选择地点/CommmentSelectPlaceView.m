//
//  CommmentSelectPlaceView.m
//  BDSAAS
//
//  Created by ebadu on 2017/11/13.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import "CommmentSelectPlaceView.h"
#import "SelectPlaceCell.h"
#import "PointModel.h"
#import "Header.h"
#import "UIView+Common.h"

@interface CommmentSelectPlaceView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong)  UIView       *bottomView;
@property (nonatomic, strong)  UILabel      *topLabel;
@property (nonatomic, strong)  UIScrollView *bottomScroller;
@property (nonatomic, strong)  UIView       *bottomMiddleView;
@property (nonatomic, strong)  UITableView  *leftTableView;
@property (nonatomic, strong)  UITableView  *middleTableView;
@property (nonatomic, strong)  UITableView  *rightTableView;
@property (nonatomic, strong)  UIView       *bottomMiddleLine;

@property (nonatomic, strong)  NSArray      *data1;
@property (nonatomic, strong)  NSArray      *data2;
@property (nonatomic, strong)  NSArray      *data3;

@property (nonatomic, copy)    NSString     *middleTableviewType;
@property (nonatomic, assign)  NSInteger    selectIndex1;
@property (nonatomic, assign)  NSInteger    selectIndex2;
@property (nonatomic, assign)  NSInteger    selectIndex3;

///当前选中的是第几级 1 2 3
@property (nonatomic, assign)  NSInteger    index;
///第二级是否选中
@property (nonatomic, assign)  BOOL         isSelelc1;
///第三级是否选中
@property (nonatomic, assign)  BOOL         isSelelc2;

@property (nonatomic, strong)  UIButton     *selectBtn;
@property (nonatomic, strong)  UIButton     *sureBtn;

@end

static NSString *middleType1 = @"normal";
static NSString *middleType2 = @"notNormal";

static NSString *cellId1 = @"CommmentSelectPlaceView1";
static NSString *cellId2 = @"CommmentSelectPlaceView2";
static NSString *cellId3 = @"CommmentSelectPlaceView3";

@implementation CommmentSelectPlaceView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.selectIndex1 = 0;
        self.selectIndex2 = 0;
        self.selectIndex3 = 0;
        self.middleTableviewType = middleType1;
        self.index = 1;
        self.isSelelc1 = NO;
        self.isSelelc2 = NO;
        
        
        
        [self addSubview:self.bottomView];
        
        [self setLocationData];
        
    }
    return self;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT() - 440, SCREENWIDTH(), 440)];
        _bottomView.backgroundColor = HexColor(@"ffffff");
        
        self.topLabel.hidden = NO;
        [_bottomView addSubview:self.bottomMiddleView];
        [_bottomView addSubview:self.bottomScroller];
        
    }
    return _bottomView;
}

- (UILabel *)topLabel{
    
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH(), 40)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"所在地区";
        _topLabel.textColor = HexColor(@"777777");
        _topLabel.font = UIFontSize(15);
        _topLabel.backgroundColor = HexColor(@"ebf0f4");
        [_bottomView addSubview:_topLabel];
        
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 40)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:HexColor(@"596c83") forState:UIControlStateNormal];
        cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancleBtn.titleLabel.font = UIFontSize(14);
        cancleBtn.backgroundColor = HexColor(@"ebf0f4");
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancleBtn];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH() - 20 - 50, 0, 50, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = UIFontSize(14);
        [sureBtn setTitleColor:HexColor(@"596c83") forState:UIControlStateNormal];
        [sureBtn setTitleColor:HexColor(@"777777") forState:UIControlStateDisabled];
        sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        sureBtn.backgroundColor = HexColor(@"ebf0f4");
        sureBtn.enabled = NO;
        self.sureBtn = sureBtn;
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sureBtn];
        
    }
    return _topLabel;
    
}

- (UIView *)bottomMiddleView{
    
    if (!_bottomMiddleView) {
        _bottomMiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topLabel.bottom, SCREENWIDTH(), 45)];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH(), 0.5)];
        line.backgroundColor = HexColor(@"bbc3cc");
        [_bottomMiddleView addSubview:line];
        
        [_bottomMiddleView addSubview:self.bottomMiddleLine];
        
    }
    return _bottomMiddleView;
    
}

- (UIView *)bottomMiddleLine{
    
    if (!_bottomMiddleLine) {
        
        _bottomMiddleLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 100, 1)];
        _bottomMiddleLine.backgroundColor = DefaultBlueColor();
        
        
    }
    return _bottomMiddleLine;
}

- (UIScrollView *)bottomScroller{
    
    if (!_bottomScroller) {
        _bottomScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.bottomMiddleView.bottom, SCREENWIDTH(), 440 - 85)];
        _bottomScroller.delegate = self;
        _bottomScroller.scrollEnabled = NO;
        
        [_bottomScroller addSubview:self.leftTableView];
        [_bottomScroller addSubview:self.middleTableView];
        [_bottomScroller addSubview:self.rightTableView];
        
        _bottomScroller.contentSize = CGSizeMake(3 * SCREENWIDTH()/2.0, 440 - 85);
    }
    return _bottomScroller;
}

-(UITableView *)leftTableView{
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH()/2.0, self.bottomScroller.height) style:UITableViewStylePlain];
        
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        _leftTableView.estimatedRowHeight = 45;
        _leftTableView.rowHeight = UITableViewAutomaticDimension;
        _leftTableView.separatorColor = HexColor(@"ebf0f4");
        _leftTableView.tableFooterView = [UIView new];
    }
    return _leftTableView;
}

-(UITableView *)middleTableView{
    
    if (!_middleTableView) {
        _middleTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH()/2.0, 0, SCREENWIDTH()/2.0, self.bottomScroller.height) style:UITableViewStylePlain];
        
        _middleTableView.delegate = self;
        _middleTableView.dataSource = self;
        
        _middleTableView.estimatedRowHeight = 45;
        _middleTableView.rowHeight = UITableViewAutomaticDimension;
        _middleTableView.separatorColor = HexColor(@"e5e9ed");
        _middleTableView.tableFooterView = [UIView new];
    }
    return _middleTableView;
}

-(UITableView *)rightTableView{
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREENWIDTH(), 0, SCREENWIDTH()/2.0, self.bottomScroller.height) style:UITableViewStylePlain];
        
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        _rightTableView.estimatedRowHeight = 45;
        _rightTableView.rowHeight = UITableViewAutomaticDimension;
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
    
}


#pragma mark---私有的方法
- (void)show{
    
    [delegateWindow addSubview:self];
    self.bottomView.frame = CGRectMake(0, SCREENHEIGHT(), SCREENWIDTH(), 440);
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
       self.backgroundColor = defaultMaskViewColor();
       self.bottomView.frame = CGRectMake(0, SCREENHEIGHT() - 440, SCREENWIDTH(), 440);
    }];
   
    
}

- (void)dismiss{
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomView.frame = CGRectMake(0, SCREENHEIGHT(), SCREENWIDTH(), 440);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   
    
}

- (void)cancleAction{
    
    [self dismiss];
}

- (void)sureAction{
    
//    NSLog(@"s1");
//    AreaModel *model = nil;
    
    NSString *areaString = nil;
    NSString *areaCode = nil;
    
    if (self.index == 1) {
        AreaModel *model = self.data1[self.selectIndex1];
        areaString = model.name;
        areaCode = model.code;
        
        
    } else if (self.index == 2) {
        AreaModel *model1 = self.data1[self.selectIndex1];
        AreaModel *model2 = self.data2[self.selectIndex2];
        areaString = [NSString stringWithFormat:@"%@%@",model1.name,model2.name];
        areaCode = model2.code;
        
        
    } else if (self.index == 3) {
        AreaModel *model1 = self.data1[self.selectIndex1];
        AreaModel *model2 = self.data2[self.selectIndex2];
        AreaModel *model3 = self.data3[self.selectIndex3];
        areaString = [NSString stringWithFormat:@"%@%@%@",model1.name,model2.name,model3.name];
        areaCode = model3.code;
        
    }
    
    if (self.commentSelectPlaceBlock) {
        
        self.commentSelectPlaceBlock(areaString, areaCode);
        
    }
    
    [self dismiss];
}

- (void)setLocationData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityDat.json" ofType:nil];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArr = [PointModel modelWithJSONArr:arr];
    self.data1 = [dataArr mutableCopy];
    AreaModel *model1 = [dataArr firstObject];
    self.data2 = [model1.dataArr mutableCopy];
    AreaModel *model2 = [model1.dataArr firstObject];
    self.data3 = [model2.dataArr mutableCopy];
    
    [self.leftTableView reloadData];
    [self.middleTableView reloadData];
    [self.rightTableView reloadData];
    
    [self setTopViewBtn:1];
    
}

- (void)setTopViewBtn:(NSInteger )count{
    
    for (UIView *view in self.bottomMiddleView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    CGFloat marginX = 20;
    CGFloat width = marginX;
    
    for (NSInteger index = 0; index < count; index ++) {
        
        NSString *string = nil;
        if (index == 0) {
            AreaModel *model = self.data1[self.selectIndex1];
            string = model.name;
        }
        
        if (index == 1) {
            AreaModel *model = self.data2[self.selectIndex2];
            string = model.name;
            
        }
        
        if (index == 2) {
            AreaModel *model = self.data3[self.selectIndex3];
            string = model.name;
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(width, 0, 100, 44)];
        button.titleLabel.font = UIFontSize(14);
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:DefaultBlueColor() forState:UIControlStateSelected];
        [button setTitleColor:HexColor(@"696c83") forState:UIControlStateNormal];
        [button sizeToFit];
        if (self.index == index + 1) {
            button.selected = YES;
            self.selectBtn = button;
            self.bottomMiddleLine.width = button.width;
            self.bottomMiddleLine.centerX = button.centerX;
            
        } else {
            button.selected = NO;
            
        }
        button.tag = index + 1366;
        [button addTarget:self action:@selector(bottomMiddleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.x = width;
        button.y = (44 - button.height)/2.0;
        width += button.width + marginX;
        
        [self.bottomMiddleView addSubview:button];
        
    }
    
}

- (void)bottomMiddleBtnAction:(UIButton *)btn{
    
    if (self.selectBtn == btn) {
        return;
    }
    
    NSInteger tag = btn.tag - 1366;
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
    NSString * string = btn.titleLabel.text;
    CGFloat width = [self getWidthWithTitle:string font:UIFontSize(14)];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.bottomMiddleLine.width = width;
        self.bottomMiddleLine.centerX = btn.centerX;
        
    }];
    
    if (tag == 0) {
        
        if (self.data3.count > 0) {
            
            self.middleTableviewType = middleType1;
            [self.bottomScroller setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
        
        [self.middleTableView reloadData];
        [self.rightTableView reloadData];
        
    } else if (tag == 1) {
        
        if (self.data3.count > 0) {
            
            self.middleTableviewType = middleType2;
            [self.bottomScroller setContentOffset:CGPointMake(SCREENWIDTH()/2.0, 0) animated:YES];
            
        }
        
        [self.middleTableView reloadData];
        [self.rightTableView reloadData];
        
    }
    
}

#pragma  mark---<UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.leftTableView) {
        
        return self.data1.count;
        
    } else if (tableView == self.middleTableView) {
        
        return self.data2.count;
        
    } else if (tableView == self.rightTableView ) {
        
        return self.data3.count;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectPlaceCell *cell = nil;
    
    if (tableView == self.leftTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        
        if (!cell) {
            cell = [[SelectPlaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
            
        }
        
        if (indexPath.row < self.data1.count) {
            
            cell.model = self.data1[indexPath.row];
            
        }
        
        if (indexPath.row == self.selectIndex1) {
            
            cell.contentLabel.textColor = DefaultBlueColor();
            cell.imageV.hidden = NO;
            
        } else {
            
            cell.contentLabel.textColor = HexColor(@"28405e");
            cell.imageV.hidden = YES;
        }
        
    } else if (tableView == self.middleTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        
        if (!cell) {
            cell = [[SelectPlaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
            
        }
        
        if (indexPath.row < self.data2.count) {
            cell.model = self.data2[indexPath.row];
            
        }
        
        if ([self.middleTableviewType isEqualToString:middleType1]) {
            cell.imageV.hidden = YES;
            cell.backgroundColor = HexColor(@"ebf0f4");
            self.middleTableView.separatorColor = HexColor(@"e5e9ed");
            
            if (indexPath.row == self.selectIndex2 && self.isSelelc1) {
                cell.contentLabel.textColor = DefaultBlueColor();
                
            } else {
                cell.contentLabel.textColor = HexColor(@"28405e");
                
            }
            
            
        } else {
            
            self.middleTableView.separatorColor = HexColor(@"ebf0f4");
            cell.backgroundColor = HexColor(@"ffffff");
            if (indexPath.row == self.selectIndex2 && self.isSelelc1) {
                cell.imageV.hidden = NO;
                cell.contentLabel.textColor = DefaultBlueColor();
                
            } else {
                cell.imageV.hidden = YES;
                cell.contentLabel.textColor = HexColor(@"28405e");
                
            }
            
        }
        
    } else if (tableView == self.rightTableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId3];
        
        if (!cell) {
            cell = [[SelectPlaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId3];
            cell.imageV.hidden = YES;
            cell.backgroundColor = HexColor(@"ebf0f4");
            tableView.separatorColor = HexColor(@"e5e9ed");
        }
        
        
        if (indexPath.row == self.selectIndex3 && self.isSelelc2) {
            cell.contentLabel.textColor = DefaultBlueColor();
            
        } else {
            cell.contentLabel.textColor = HexColor(@"28405e");
            
        }
        
        if (indexPath.row < self.data3.count) {
            cell.model = self.data3[indexPath.row];
            
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        
        
        if (indexPath.row == self.selectIndex1) {
            
            return;
        }
        
        self.selectIndex1 = indexPath.row;
        self.middleTableviewType = middleType1;
        AreaModel *model1 = self.data1[indexPath.row];
        self.data2 = [model1.dataArr mutableCopy];
        AreaModel *model2 = [model1.dataArr firstObject];
        self.data3 = [model2.dataArr mutableCopy];
        self.selectIndex2 = 0;
        self.selectIndex3 = 0;
        
        [self setTopViewBtn:1];
        self.isSelelc1 = NO;
        self.isSelelc2 = NO;
        
        [self.leftTableView reloadData];
        [self.middleTableView reloadData];
        [self.rightTableView reloadData];
        
        if (!self.data2.count) {
            
            self.sureBtn.enabled = YES;
            
        } else {
            
            self.sureBtn.enabled = NO;
            
        }
        
        
    } else if (tableView == self.middleTableView) {
        
        self.isSelelc1 = YES;
        AreaModel *model = self.data2[indexPath.row];
        self.data3 = [model.dataArr mutableCopy];
        self.selectIndex2 = indexPath.row;
        self.selectIndex3 = 0;
        self.isSelelc2 = NO;
        
        if (self.data3.count) {
            
            self.sureBtn.enabled = NO;
            self.middleTableviewType = middleType2;
            [self.bottomScroller setContentOffset:CGPointMake(SCREENWIDTH()/2.0, 0) animated:YES];
            self.bottomScroller.bouncesZoom = NO;

        } else {
            self.sureBtn.enabled = YES;
            
        }
        
        self.index = 2;
        [self setTopViewBtn:2];
        [self.middleTableView reloadData];
        [self.rightTableView reloadData];
        
        
    } else {
        
        self.isSelelc2 = YES;
        self.selectIndex3 = indexPath.row;
        self.sureBtn.enabled = YES;
        
        self.index = 3;
        [self setTopViewBtn:3];
        [self.rightTableView reloadData];
    }
    
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
