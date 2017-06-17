//
//  ScanImageViewController.h
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanImageViewControllerDelegate <NSObject>

- (void)getDatasource:(NSMutableArray *)datasource;

@end

@interface ScanImageViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) id<ScanImageViewControllerDelegate> delegate;
@end
