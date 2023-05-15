//
//  SHTagViewCollectionViewCell.m
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import "SHTagViewCollectionViewCell.h"
#import "Masonry.h"
#import "UIView+SHExtension.h"
#import "UIButton+SHExtension.h"

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

- (void)setTagView:(SHTagView *)tagView{
    _tagView = tagView;
    [self.closeBtn setBackgroundImage:tagView.closeImg forState:UIControlStateNormal];
    [self.closeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(tagView.closeWH);
    }];
    [self.contentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(tagView.closeWH/2);
        make.right.mas_offset(-tagView.closeWH/2);
    }];
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

- (void)setIsTop:(BOOL)isTop{
    _isTop = isTop;
    [self handleBtn];
}

- (void)handleBtn{
    
    self.contentBtn.titleLabel.font = self.tagView.font;
    [self.contentBtn setTitle:[NSString stringWithFormat:@"%@",self.data.name] forState:UIControlStateNormal];
    //下方字体颜色
    [self.contentBtn setTitleColor:self.tagView.downColor forState:UIControlStateNormal];
    [self.contentBtn setImage:self.tagView.addImg forState:UIControlStateNormal];
    self.contentBtn.backgroundColor = [UIColor clearColor];
    self.contentBtn.layer.borderColor = self.contentBtn.titleLabel.textColor.CGColor;
    [self.contentBtn imageDirection:SHButtonImageDirection_left space:self.tagView.addSpace];
    self.closeBtn.hidden = YES;
    if (self.isTop) {
        //上方字体颜色
        [self.contentBtn setTitleColor:self.tagView.topColor forState:UIControlStateNormal];
        [self.contentBtn setImage:nil forState:UIControlStateNormal];
        self.contentBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.027];
        self.contentBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.contentBtn imageDirection:SHButtonImageDirection_left space:0];
        if (self.canEdit) {//可编辑
            self.closeBtn.hidden = !self.tagView.isEdit;
            self.contentBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        }
        if (self.isSelect) {//选中
            [self.contentBtn setTitleColor:self.tagView.selectColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 懒加载
- (UIButton *)contentBtn{
    if (!_contentBtn) {
        _contentBtn = [[UIButton alloc]init];
        _contentBtn.layer.borderWidth = 0.5;
        _contentBtn.layer.cornerRadius = 4;
        _contentBtn.enabled = NO;
        [self.contentView addSubview:_contentBtn];
        
        [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
    }
    return _contentBtn;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [self.contentView addSubview:_closeBtn];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(0);
            make.top.right.mas_offset(0);
        }];
        __weak __typeof__(self) weak_self = self;
        [_closeBtn addClickBlock:^(UIButton * _Nonnull btn) {
            if (weak_self.cellBack) {
                weak_self.cellBack();
            }
        }];
    }
    return _closeBtn;
}

@end
