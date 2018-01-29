//
//  PointModel.h
//  PointerDemo
//
//  Created by kjlink on 2017/2/25.
//  Copyright © 2017年 kjlink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaModel.h"
#import "CityModel.h"

@interface PointModel : NSObject

@property (nonatomic, strong ) NSArray *dataArr;


+ (NSArray *)modelWithJSONArr:(NSArray *)arr;

@end








