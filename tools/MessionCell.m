//
//  MessionCell.m
//  tools
//
//  Created by guest on 16/8/10.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "MessionCell.h"
#import "ShopMession.h"
@interface MessionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fruitImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end


@implementation MessionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)cellCommitAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(messionCell:commitWithShopId:)]) {
        [_delegate performSelector:@selector(messionCell:commitWithShopId:) withObject:self withObject:self.shopMession.shopId];
    }
}

- (void)setShopMession:(ShopMession *)shopMession{
    if (_shopMession != shopMession) {
        _shopMession = shopMession;
    }
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:_shopMession.shopOuterImages[0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData: imageData];
    _fruitImageView.image = image;
    _shopName.text = _shopMession.shopName;
    _typeLabel.text = _shopMession.shopType;
    _createTimeLabel.text = _shopMession.creat_time;

}
//- (void)setShopData:(ShopData *)shopData{
//    if (_shopData != shopData) {
//        _shopData = shopData;
//    }
//    
////    NSLog(@"%@",_shopData.shopImageDatas[0]);
//    
//    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:_shopData.shopImageDatas[0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    UIImage *image = [UIImage imageWithData: imageData];
//    _fruitImageView.image = image;
//    _shopName.text = _shopData.name;
//    _addressLabel.text = _shopData.address;
//    _createTimeLabel.text = _shopData.creat_time;
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
