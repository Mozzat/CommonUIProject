//
//  ViewController.m
//  CommonUI
//
//  Created by ebadu on 2018/1/29.
//  Copyright © 2018年 ebadu. All rights reserved.
//

#import "ViewController.h"
#import "CommmentSelectPlaceView.h"
#import "CommentDatePickerView.h"
#import "Header.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel       *titleLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH(), 64)];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH(), SCREENHEIGHT() - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark---<UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray *titleArr = @[@"选择地点",@"选择时间"];
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        CommmentSelectPlaceView *placeView = [[CommmentSelectPlaceView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH(), SCREENHEIGHT())];
        [placeView show];
        
        LRWeakSelf(self);
        placeView.commentSelectPlaceBlock = ^(NSString *areaStr, NSString *areaCode) {
            LRStrongSelf(self);
            
            self.titleLab.text = areaStr;
            
        } ;
        
    } else {
        
        LRWeakSelf(self);
        CommentDatePickerView *picker = [[CommentDatePickerView alloc]initWithComDatePickType:ComDatePickTypeYearMonthDayHourMinute WithBlock:^(NSDate *date) {
            
            LRStrongSelf(self);
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
            dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *titleStr = [dateFormater stringFromDate:date];
            self.titleLab.text = titleStr;
        
        }];
        [picker show];
        
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
