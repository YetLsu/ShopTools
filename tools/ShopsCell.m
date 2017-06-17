//
//  ShopsCell.m
//  tools
//
//  Created by guest on 16/8/13.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ShopsCell.h"
#import "ShopModel.h"
@interface ShopsCell ()
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end


@implementation ShopsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShopModel:(ShopModel *)shopModel{
    if (_shopModel != shopModel) {
        _shopModel = shopModel;
    }
    _shopNameLabel.text = _shopModel.name;
    _addressLabel.text = _shopModel.address;
    _distanceLabel.text = [NSString stringWithFormat:@"%ldm",_shopModel.juli];
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
