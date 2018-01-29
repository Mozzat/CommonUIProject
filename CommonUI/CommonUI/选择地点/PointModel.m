//
//  PointModel.m
//  PointerDemo
//
//  Created by kjlink on 2017/2/25.
//  Copyright © 2017年 kjlink. All rights reserved.
//

#import "PointModel.h"

@implementation PointModel

+ (NSArray *)modelWithJSONArr:(NSArray *)arr{
    
    NSMutableArray *arr1 = [NSMutableArray array];
    
    //1.取出包含省数组中的一个省,
    //2.判断省里面有多少个事
    for (NSInteger index = 0; index< arr.count; index ++) {
        
        NSDictionary *dic = arr[index];
        AreaModel *arae = [[AreaModel alloc]init];
        arae.name = dic[@"name"];
        arae.code = dic[@"code"];
        
        //获取市中的数组
        NSArray *cityArr = dic[@"children"];
        NSMutableArray *cityModelArr = [NSMutableArray array];
        for (NSInteger i = 0; i < cityArr.count; i ++) {
            NSDictionary *cityDic = cityArr[i];
            AreaModel *cityModel = [[AreaModel alloc]init];
            cityModel.name = cityDic[@"name"];
            cityModel.code = cityDic[@"code"];
            
            //获取区县的数组
            NSArray *areaArr = cityDic[@"children"];
            NSMutableArray *areaModelArr = [NSMutableArray array];
            for (NSInteger j= 0; j < areaArr.count; j ++) {
                NSDictionary *areaDic = areaArr[j];
                AreaModel *areaModel = [[AreaModel alloc]init];
                areaModel.name = areaDic[@"name"];
                areaModel.code = areaDic[@"code"];
                [areaModelArr addObject:areaModel];
                
            }
            cityModel.dataArr = [areaModelArr copy];
            [cityModelArr addObject:cityModel];
            
        }
        arae.dataArr = [cityModelArr copy];
        [arr1 addObject:arae];
        
    }
    
    return [arr1 copy];
}

@end


