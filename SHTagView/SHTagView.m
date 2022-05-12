//
//  SHTagView.m
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import "SHTagView.h"
#import "SHTagViewCollectionViewCell.h"
#import "UIView+SHExtension.h"

@interface SHTagView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation SHTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.space = 15;
        self.lineSpace = 10;
        self.column = 4;
        self.tagH = 35;
        
        UILabel *head = [[UILabel alloc]init];
        head.frame = CGRectMake(10, 0, 200, 40);
        head.text = @"全部频道";
        self.sectionView = head;
        
        NSString *path = [[NSBundle bundleWithPath:[self getBundle]] pathForResource:@"add@2x" ofType:@"png"];
        self.addImg = [UIImage imageWithContentsOfFile:path];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

#pragma mark - 私有方法
#pragma mark 获取Bundle路径
- (NSString *)getBundle{
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"SHTagView" ofType:@"bundle"];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[SHTagViewCollectionViewCell class] forCellWithReuseIdentifier:@"SHTagViewCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionElementKindSectionHeader];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.selectArr.count;
    }
    return self.unSelectArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SHTagViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTagViewCollectionViewCell" forIndexPath:indexPath];
    cell.isTop = NO;
    cell.isEdit = self.isEdit;
    SHTagViewModel *data;
    if (indexPath.section == 0) {
        data = self.selectArr[indexPath.row];
        cell.isTop = YES;
        cell.canEdit = NO;
        if (indexPath.row > self.editIndex) {
            cell.canEdit = YES;
        }
    }else{
        data = self.unSelectArr[indexPath.row];
    }
    cell.addImg = self.addImg;
    cell.data = data;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            [headerView addSubview:self.sectionView];
        }
        
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SHTagViewModel *data;
    if (indexPath.section == 0) {
        data = self.selectArr[indexPath.row];
    }else{
        data = self.unSelectArr[indexPath.row];
    }
    CGFloat tagW = data.tagW;
    if (tagW <= 0) {
        tagW = (CGRectGetWidth(collectionView.frame) - self.space*(self.column + 1))/self.column;
    }
    return CGSizeMake(tagW, self.tagH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.lineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.space;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(self.lineSpace, self.space, self.lineSpace, self.space);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.sectionView.size;
    }
    return CGSizeZero;
}

#pragma mark - 公开方法
- (void)reloadView{
    [self layoutIfNeeded];
    [self.collectionView reloadData];
}

@end

