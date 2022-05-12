//
//  SHTagViewCollectionViewCell.h
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "SHTagViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHTagViewCollectionViewCell : UICollectionViewCell

//数据源
@property (nonatomic, strong) SHTagViewModel *data;

//是否可以编辑
@property (nonatomic, assign) BOOL canEdit;
//是否编辑
@property (nonatomic, assign) BOOL isEdit;
//是否选中
@property (nonatomic, assign) BOOL isSelect;
//是否顶部
@property (nonatomic, assign) BOOL isTop;
//添加图片
@property (nonatomic, strong) UIImage *addImg;

@end

NS_ASSUME_NONNULL_END
