//
//  SHTagView.m
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import "SHTagView.h"
#import "SHTagViewCollectionViewCell.h"
#import "UIView+SHExtension.h"

@interface SHTagView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
//选中cell的NSIndexPath
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGPoint currentPoint;
@property (strong, nonatomic) UIView *currentView;

@end

@implementation SHTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.closeWH = 17;
        self.space = 15 - self.closeWH / 2;
        self.lineSpace = 10 - self.closeWH / 2;
        self.column = 4;
        self.tagH = 35 + self.closeWH / 2;
        self.selectColor = [UIColor orangeColor];
        self.panScale = 1.2;
        
        UILabel *head = [[UILabel alloc] init];
        head.frame = CGRectMake(10, 0, 200, 40);
        head.text = @"全部频道";
        self.sectionView = head;
        
        NSBundle *bundle = [NSBundle bundleWithPath:[self getBundle]];
        
        NSString *path = [bundle pathForResource:@"add@2x" ofType:@"png"];
        self.addImg = [UIImage imageWithContentsOfFile:path];
        
        path = [bundle pathForResource:@"close@2x" ofType:@"png"];
        self.closeImg = [UIImage imageWithContentsOfFile:path];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

#pragma mark - 私有方法
#pragma mark 获取Bundle路径
- (NSString *)getBundle {
    return [[NSBundle bundleForClass:[self class]] pathForResource:@"SHTagView" ofType:@"bundle"];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
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
        
        [self.collectionView addGestureRecognizer:self.longGesture];
        [self.collectionView addGestureRecognizer:self.panGesture];
    }
    return _collectionView;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
        _longGesture.delegate = self;
    }
    return _longGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTagViewModel *data;
    @try {
        if (indexPath.section == 0) {
            data = self.selectArr[indexPath.row];
        } else {
            data = self.unSelectArr[indexPath.row];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
    
    CGFloat tagW = data.tagW;
    if (tagW <= 0) {
        tagW = (CGRectGetWidth(collectionView.frame) - self.space * (self.column + 1)) / self.column;
    }
    return CGSizeMake(tagW, self.tagH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.space;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.lineSpace, self.space, self.lineSpace, self.space);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.sectionView.size;
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectArr.count;
    }
    return self.unSelectArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHTagViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SHTagViewCollectionViewCell" forIndexPath:indexPath];
    cell.tagView = self;
    __weak __typeof__(self) weak_self = self;
    cell.cellBack = ^{
        [weak_self deleteAction:indexPath];
    };
    
    cell.isTop = NO;
    cell.isSelect = NO;
    SHTagViewModel *data;
    if (indexPath.section == 0) {
        data = self.selectArr[indexPath.row];
        cell.isTop = YES;
        cell.canEdit = NO;
        if (indexPath.row > self.editIndex) {
            cell.canEdit = YES;
        }
        if (indexPath.row == self.currentIndex) {
            cell.isSelect = YES;
        }
    } else {
        data = self.unSelectArr[indexPath.row];
    }
    cell.data = data;
    cell.contentView.alpha = 1;
    if (self.indexPath && self.isEdit) {
        if (self.indexPath == indexPath) {
            cell.contentView.alpha = 0;
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        
        if (indexPath.section == 1) {
            [headerView addSubview:self.sectionView];
        }

        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击标签逻辑
    if (indexPath.section == 0) {
        if (self.isEdit) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            //变大动画
            [UIView animateWithDuration:0.2
                             animations:^{
                cell.transform = CGAffineTransformMakeScale(self.panScale, self.panScale);
            } completion:^(BOOL finished) {
                cell.transform = CGAffineTransformMakeScale(1, 1);
            }];
            
        } else {
            //非编辑点击 选中
            self.currentIndex = indexPath.row;
            [collectionView reloadData];
        }
    } else {
        SHTagViewModel *data = self.unSelectArr[indexPath.row];
        [self.selectArr addObject:data];
        [self.unSelectArr removeObjectAtIndex:indexPath.row];
        
        //选中最后一个
        self.currentIndex = self.selectArr.count - 1;
        
        //动画
        [collectionView
         performBatchUpdates:^{
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:self.selectArr.count - 1 inSection:0]];
        }
         completion:^(BOOL finished) {
            [collectionView reloadData];
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    //取出操作的 indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        //手势生效(编辑状态、第一组、可编辑)
        BOOL gesture = (self.isEdit && indexPath.section == 0 && indexPath.row > self.editIndex);
        
        //拖拽
        if (gestureRecognizer == self.panGesture) {
            if (indexPath) {
                if (gesture) {
                    self.indexPath = indexPath;
                    return YES;
                }
            }
            return NO;
        }
        
        //长按
        if (gestureRecognizer == self.longGesture) {
            if (!(self.isEdit && indexPath.section == 0)) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 手势
#pragma mark 长按
- (void)longAction:(UILongPressGestureRecognizer *)press {
    switch (press.state) {
        case UIGestureRecognizerStateBegan: {
            //开启编辑
            self.isEdit = YES;
        } break;
        default:
            break;
    }
}

#pragma mark 拖拽
- (void)panAction:(UIPanGestureRecognizer *)press {
    //拖拽标签逻辑
    CGPoint location = [press locationInView:self.collectionView];
    switch (press.state) {
        case UIGestureRecognizerStateBegan: {
            [self preparePan:location];
        } break;
        case UIGestureRecognizerStateChanged: {
            //设置位置
            self.currentView.x = location.x - self.currentPoint.x;
            self.currentView.y = location.y - self.currentPoint.y;
            
            //获取要替换的位置
            NSIndexPath *new = [self.collectionView indexPathForItemAtPoint : location ];
            if (!new) {
                break;
            }
            
            if (new.section == 0) {
                //可编辑
                if (new.row > self.editIndex) {
                    //编辑数据源
                    NSMutableArray *temp = [self.selectArr mutableCopy];
                    if (new.row > self.indexPath.row) {
                        //替换位置 比 编辑的大(移动到后面)
                        for (NSInteger index = self.indexPath.row; index < new.row; index++) {
                            //交换元素
                            [temp exchangeObjectAtIndex:index withObjectAtIndex:index + 1];
                        }
                    }
                    if (new.row < self.indexPath.row) {
                        //替换位置 比 编辑的小(移动到前面)
                        for (NSInteger index = self.indexPath.row; index > new.row; index--) {
                            //交换元素
                            [temp exchangeObjectAtIndex:index withObjectAtIndex:index - 1];
                        }
                    }
                    
                    //更新数据源
                    self.selectArr = temp;
                    //动画
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView moveItemAtIndexPath:self.indexPath toIndexPath:new];
                    } completion:^(BOOL finished) {
                        [self.collectionView reloadData];
                    }];
                    //新位置
                    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:new];
                    cell.alpha = 0.f;
                    self.indexPath = new;
                }
            }
            if (new.section == 1) {//拖拽到下方
                //编辑数据源
                //取出
                SHTagViewModel *data = self.selectArr[self.indexPath.row];
                //删除
                [self.selectArr removeObjectAtIndex:self.indexPath.row];
                //添加
                [self.unSelectArr addObject:data];
                
                //选中位置
                if (self.indexPath.row == self.currentIndex) {
                    self.currentIndex = self.selectArr.count - 1;
                }

                //动画
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView moveItemAtIndexPath:self.indexPath toIndexPath:[NSIndexPath indexPathForItem:self.unSelectArr.count - 1 inSection:1]];
                } completion:^(BOOL finished) {
                    [self.collectionView reloadData];
                }];
                press.state = UIGestureRecognizerStateEnded;
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            self.indexPath = nil;
            [self.currentView removeFromSuperview];
            [self.collectionView reloadData];
        } break;
        default:
            break;
    }
}

#pragma mark 准备拖拽
- (void)preparePan:(CGPoint)location {
    [self.currentView removeFromSuperview];
    //获取手指按住的cell
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
    //截取当前cell截图
    self.currentView = [cell snapshotViewAfterScreenUpdates:NO];
    self.currentView.layer.maskedCorners = NO;
    self.currentView.center = cell.center;
    // 记录当前手指的位置的x和y距离cell的x,y的间距
    self.currentPoint = CGPointMake(location.x - cell.frame.origin.x, location.y - cell.frame.origin.y);
    // 放大截图
    self.currentView.transform = CGAffineTransformMakeScale(self.panScale, self.panScale);
    // 添加截图到collectionView上
    [self.collectionView addSubview:self.currentView];
    // 隐藏当前cell
    cell.alpha = 0.f;
}

#pragma mark - 事件
- (void)deleteAction:(NSIndexPath *)indexPath{
    //编辑点击 删除
    if (indexPath.row <= self.editIndex) {
        //不可编辑
        return;
    }
    SHTagViewModel *data = self.selectArr[indexPath.row];
    [self.selectArr removeObjectAtIndex:indexPath.row];
    [self.unSelectArr addObject:data];
    
    if (indexPath.row < self.currentIndex) {
        //删除前面的
        self.currentIndex--;
    }
    
    //动画
    [self.collectionView
     performBatchUpdates:^{
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:self.unSelectArr.count - 1 inSection:1]];
    }
     completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}
#pragma mark - 公开方法
- (void)reloadView {
    [self layoutIfNeeded];
    [self.collectionView reloadData];
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    [self.collectionView reloadData];
    if (self.block) {
        self.block(self);
    }
}

@end
