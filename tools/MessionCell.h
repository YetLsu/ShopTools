//
//  MessionCell.h
//  tools
//
//  Created by guest on 16/8/10.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopMession;
@class MessionCell;
@protocol MessionCellDelegate <NSObject>

- (void)messionCell:(MessionCell *)cell commitWithShopId:(NSString *)shopId;

@end

@interface MessionCell : UITableViewCell

//@property (nonatomic, strong) ShopData *shopData;
@property (nonatomic, strong) ShopMession *shopMession;
@property (nonatomic, assign) id<MessionCellDelegate> delegate;
@end
