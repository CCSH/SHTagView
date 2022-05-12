//
//  ViewController.m
//  Example
//
//  Created by 陈胜辉 on 2022/1/11.
//

#import "ViewController.h"
#import "SHTagView.h"
#import <UIView+SHExtension.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *topLab = [[UILabel alloc]init];
    topLab.text = @"我的频道";
    topLab.frame = CGRectMake(10, 100, self.view.width - 2*10, 40);
    [self.view addSubview:topLab];
    
    SHTagView *view = [[SHTagView alloc]init];
    view.frame = CGRectMake(0, topLab.maxY, self.view.frame.size.width, 500);
    NSMutableArray *selectArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        SHTagViewModel *model = [[SHTagViewModel alloc]init];
        model.name = [NSString stringWithFormat:@"标签--%d",i];
        [selectArr addObject:model];
    }
    view.selectArr = selectArr;
    
    NSMutableArray *unSelectArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 50; i++) {
        SHTagViewModel *model = [[SHTagViewModel alloc]init];
        model.name = [NSString stringWithFormat:@"标签2--%d",i];
        [unSelectArr addObject:model];
    }
    view.unSelectArr = unSelectArr;
    [view reloadView];

    view.block = ^(SHTagView * _Nonnull tag) {
        NSLog(@"选中--%@",tag.selectArr);
        NSLog(@"未选中--%@",tag.unSelectArr);
        NSLog(@"选中位置---%ld",(long)tag.index);
    };
    
    [view reloadView];
    [self.view addSubview:view];

}


@end
