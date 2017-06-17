//
//  UpMessionViewCell.m
//  tools
//
//  Created by guest on 16/8/24.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "UpMessionViewCell.h"

@implementation UpMessionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _shopImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_shopImageView];
    }
    return self;
    
}
@end
