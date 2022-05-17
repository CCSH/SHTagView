//
//  SHTagView.h
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "SHTagViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 标签页
@interface SHTagView : UIView

//回调
typedef void(^CallBack)(SHTagView *tag);

#pragma mark - 必传
@property (nonatomic, strong) NSMutableArray <SHTagViewModel *>*selectArr;
@property (nonatomic, strong) NSMutableArray <SHTagViewModel *>*unSelectArr;

//回调
@property (nonatomic, copy) CallBack block;
//选中位置
@property (nonatomic, assign) NSInteger currentIndex;

#pragma mark - 选传
//前几个不能编辑
@property (nonatomic, assign) NSInteger editIndex;
//编辑状态
@property (nonatomic, assign) BOOL isEdit;

#pragma mark 界面定制(待补充)
//几列(默认4)
@property (nonatomic, assign) NSInteger column;
//拖拽比例(默认 1.2)
@property (nonatomic, assign) CGFloat panScale;

//关闭按钮宽高(默认 17)
@property (nonatomic, assign) CGFloat closeWH;
//高度(默认35 + closeWH/2)
@property (nonatomic, assign) CGFloat tagH;
//左右间隙(默认15 - closeWH/2)
@property (nonatomic, assign) CGFloat space;
//行间距(默认10 - closeWH/2)
@property (nonatomic, assign) CGFloat lineSpace;

//选中颜色(默认orangeColor)
@property (nonatomic, assign) UIColor *selectColor;
//组头
@property (nonatomic, strong) UIView *sectionView;
//添加图片
@property (nonatomic, strong) UIImage *addImg;
//关闭图片
@property (nonatomic, strong) UIImage *closeImg;

#pragma mark - 刷新
- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
