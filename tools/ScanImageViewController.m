//
//  ScanImageViewController.m
//  tools
//
//  Created by guest on 16/8/9.
//  Copyright © 2016年 聂凡. All rights reserved.
//

#import "ScanImageViewController.h"
#import "ScanPhotoCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ScanImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
static NSString *const photoScanCellId = @"photoScanCellId";
@implementation ScanImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupContent];
}

- (void)setupNavi{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.selectedIndexPath.row + 1,self.datasource.count];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = _titleLabel;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 70, 20);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupContent{
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ScanPhotoCell class] forCellWithReuseIdentifier:photoScanCellId];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ScanPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoScanCellId forIndexPath:indexPath];
    cell.imageView.image = _datasource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/kScreenWidth;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
    _selectedIndexPath = indexPath;
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", page+1, _datasource.count];
    
}
- (void)deleteAction{
    [_datasource removeObjectAtIndex:_selectedIndexPath.row];
    if (_datasource.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (_selectedIndexPath.row == _datasource.count) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:_datasource.count-1
                                                inSection:0];
    }
    [_collectionView reloadData];
    _titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", _selectedIndexPath.row+1, _datasource.count];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(getDatasource:)]) {
        [self.delegate performSelector:@selector(getDatasource:) withObject:self.datasource];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
