//
//  CommmentSelectPlaceView.h
//  BDSAAS
//
//  Created by ebadu on 2017/11/13.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CommentSelectPlaceBlock)(NSString *areaStr , NSString *areaCode);
@interface CommmentSelectPlaceView : UIView

@property (nonatomic, copy) CommentSelectPlaceBlock commentSelectPlaceBlock;

- (void)show;

@end
