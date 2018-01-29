//
//  Header.h
//  CommonUI
//
//  Created by ebadu on 2018/1/29.
//  Copyright © 2018年 ebadu. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;
#define delegateWindow [UIApplication sharedApplication].delegate.window

static inline CGFloat SCREENWIDTH(){
    return [UIScreen mainScreen].bounds.size.width;
};

static inline CGFloat SCREENHEIGHT(){
    return [UIScreen mainScreen].bounds.size.height;
};

static inline UIColor *RGBCOLOR(CGFloat r,CGFloat g,CGFloat b){
    return [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1];
};

static inline UIColor *RGBA(CGFloat r,CGFloat g,CGFloat b,CGFloat a){
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
};

static inline UIColor *HexColor(NSString *color){
    
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@""];
    color = [color stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    long red = strtoul([[color substringWithRange:NSMakeRange(0, 2)] UTF8String] , 0, 16);
    
    long green = strtoul([[color substringWithRange:NSMakeRange(2, 2)] UTF8String] , 0, 16);
    
    long blue = strtoul([[color substringWithRange:NSMakeRange(4, 2)] UTF8String] , 0, 16);
    
    return RGBCOLOR(red, green, blue);
};

//蒙版的背景颜色
static inline UIColor *defaultMaskViewColor() {
    return RGBA(0, 0, 0, 0.6);
}

//蓝色
static inline UIColor *DefaultBlueColor() {
    return HexColor(@"07affa");
}

static inline UIFont *UIFontSize(CGFloat font){
    
    return [UIFont fontWithName:@"Helvetica" size:font];
    //    return [UIFont systemFontOfSize:font];
};

static inline UIColor *DefaultBackgroundColor() {
    return HexColor(@"fafafa");
}


#endif /* Header_h */
