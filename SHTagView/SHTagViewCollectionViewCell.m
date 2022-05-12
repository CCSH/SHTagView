//
//  SHTagViewCollectionViewCell.m
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import "SHTagViewCollectionViewCell.h"
#import "Masonry.h"
#import "UIView+SHExtension.h"

@interface SHTagViewCollectionViewCell ()

//内容
@property (nonatomic, strong) UIButton *contentBtn;
//关闭
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation SHTagViewCollectionViewCell

- (void)setData:(SHTagViewModel *)data{
    _data = data;
    [self handleBtn];
}

- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    [self handleBtn];
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    [self handleBtn];
}

- (void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    [self handleBtn];
}

- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    [self handleBtn];
}

- (void)setAddImg:(UIImage *)addImg{
    _addImg = addImg;
    [self handleBtn];
}

- (void)handleBtn{
    [self.contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentBtn drawDashedBorder:[UIColor grayColor] lineWidth:1 lineDashPattern:@[@(4),@(4)]];
    [self.contentBtn setImage:self.addImg forState:UIControlStateNormal];
    [self.contentBtn setTitle:[NSString stringWithFormat:@" %@",self.data.name] forState:UIControlStateNormal];
    self.contentBtn.backgroundColor = [UIColor whiteColor];
    if (self.isTop) {//顶部
        [self.contentBtn drawDashedBorder:[UIColor grayColor] lineWidth:1 lineDashPattern:@[@(4),@(0)]];
        self.contentBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self.contentBtn setImage:nil forState:UIControlStateNormal];
        [self.contentBtn setTitle:[NSString stringWithFormat:@"%@",self.data.name] forState:UIControlStateNormal];

        if (self.canEdit) {//可编辑
            self.contentBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        }
        
        if (self.isSelect) {//选中
            [self.contentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
}

- (void)drawDashedBorderWith:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = lineWidth;
    border.lineCap = @"square";
    // 设置线宽和线间距
    border.lineDashPattern = @[@4, @4];
    [self.layer addSublayer:border];
}

#pragma mark - 懒加载
- (UIButton *)contentBtn{
    if (!_contentBtn) {
        _contentBtn = [[UIButton alloc]init];
        _contentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _contentBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentBtn];
        
        [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
    }
    return _contentBtn;
}

@end
