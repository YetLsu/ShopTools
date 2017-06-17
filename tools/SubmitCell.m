//
//  SubmitCell.m
//  tools
//
//  Created by guest on 16/8/20.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "SubmitCell.h"
#import "SubmitShopModel.h"
#import "UIImageView+WebCache.h"
@interface SubmitCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopStreetLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitTimeLabel;

@end

@implementation SubmitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SubmitShopModel *)model{
    if (_model != model) {
        _model = model;
    }
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:_model.shopOutImages] placeholderImage:nil options:SDWebImageRetryFailed];
    _shopNameLabel.text = _model.shopName;
    _shopStreetLabel.text = _model.shopType;
    _submitTimeLabel.text = _model.creat_time;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
