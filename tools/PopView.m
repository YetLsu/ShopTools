//
//  PopView.m
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "PopView.h"
#import "UIImageView+WebCache.h"
#import "UIView+NFExtension.h"
#import "ShowImageViewController.h"
@interface PopView ()
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@end

@implementation PopView

- (void)setModel:(ShopModel *)model{
    if (_model != model) {
        _model = model;
    }
    _shopName.text = model.name;
    _address.text = model.address;
    _distance.text = [NSString stringWithFormat:@"距离：%ldm",model.juli];
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString: model.imgurl] placeholderImage:nil options:SDWebImageRetryFailed];
}


- (void)awakeFromNib{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _shopImageView.userInteractionEnabled = YES;
    [_shopImageView addGestureRecognizer:tapGR];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIViewController *vc = [self getControllerFromFirstView:self.superview];
    ShowImageViewController *showImageVc = [[ShowImageViewController alloc] init];
    showImageVc.imageUrl = self.model.imgurl;
    [vc presentViewController:showImageVc animated:YES completion:nil];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
