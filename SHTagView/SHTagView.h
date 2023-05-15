//
//  SHTagView.h
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "SHTagViewModel.h"
#import "SHCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

/// 标签页
@interface SHTagView : UIView

//回调
typedef void(^SHTagViewBack)(SHTagView *tag);

#pragma mark - 必传
@property (nonatomic, strong) NSMutableArray <SHTagViewModel *>*selectArr;
@property (nonatomic, strong) NSMutableArray <SHTagViewModel *>*unSelectArr;

//回调
@property (nonatomic, copy) SHTagViewBack block;
//选中位置
@property (nonatomic, assign) NSInteger currentIndex;

#pragma mark - 选传
//前几个不能编辑
@property (nonatomic, assign) NSInteger editIndex;
//编辑状态
@property (nonatomic, assign) BOOL isEdit;
//标签对齐方式
@property (nonatomic, assign) SHLayoutAlignment alignment;

#pragma mark 界面定制
//一行几列(默认4 与tagW有冲突 优先tagW)
@property (nonatomic, assign) NSInteger column;
//拖拽比例(默认 1.2)
@property (nonatomic, assign) CGFloat panScale;
//左右间隙(默认15)
@property (nonatomic, assign) CGFloat space;
//行间距(默认10)
@property (nonatomic, assign) CGFloat lineSpace;

#pragma mark 内容定制
//高度(默认35)
@property (nonatomic, assign) CGFloat tagH;
//上方字体颜色(默认#2F2F2F)
@property (nonatomic, copy) UIColor *topColor;
//下方字体颜色(默认#5F5F5F)
@property (nonatomic, copy) UIColor *downColor;
//选中字体颜色(默认orangeColor)
@property (nonatomic, copy) UIColor *selectColor;
//字体大小(默认14)
@property (nonatomic, copy) UIFont *font;
//添加间隔(默认5)
@property (nonatomic, assign) CGFloat addSpace;
//关闭按钮宽高(默认 15)
@property (nonatomic, assign) CGFloat closeWH;
//组头
@property (nonatomic, strong) UIView *sectionView;
//添加图片
@property (nonatomic, copy) UIImage *addImg;
//关闭图片
@property (nonatomic, copy) UIImage *closeImg;

#pragma mark - 刷新
- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
