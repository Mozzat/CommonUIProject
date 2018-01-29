//
//  SelectPlaceCell.m
//  BDSAAS
//
//  Created by ebadu on 2017/11/13.
//  Copyright © 2017年 深圳市八度云计算信息技术有限公司. All rights reserved.
//

#import "SelectPlaceCell.h"
#import <Masonry/Masonry.h>
#import "Header.h"

@interface SelectPlaceCell()

@end
@implementation SelectPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageV = [[UIImageView alloc]init];
        self.imageV.contentMode = UIViewContentModeScaleToFill;
        self.imageV.image = [UIImage imageNamed:@"选择地点勾"];
        [self.contentView addSubview:self.imageV];
        LRWeakSelf(self);
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            LRStrongSelf(self);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.width.height.mas_equalTo(15);
            
        }];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = UIFontSize(14);
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            LRStrongSelf(self);
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.right.equalTo(self.imageV.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            
        }];
        
    }
    return self;
}

- (void)setModel:(AreaModel *)model{
    
    _model = model;
    
    self.contentLabel.text = model.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
