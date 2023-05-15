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

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (nonatomic, strong) SHTagView *tagView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 50, self.view.width, 540);

    
    UILabel *topLab = [[UILabel alloc]init];
    topLab.text = @"我的频道";
    topLab.frame = CGRectMake(10, 0, self.view.width - 2*10, 40);
    [bgView addSubview:topLab];

    NSMutableArray *selectArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        SHTagViewModel *model = [[SHTagViewModel alloc]init];
        model.name = [NSString stringWithFormat:@"标签--%d",i];
        [selectArr addObject:model];
    }

    NSMutableArray *unSelectArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        SHTagViewModel *model = [[SHTagViewModel alloc]init];
        model.name = [NSString stringWithFormat:@"标签2--%d",i];
        model.tagW = 150;
        [unSelectArr addObject:model];
    }
//    
    SHTagView *view = [[SHTagView alloc]init];
    view.frame = CGRectMake(0, topLab.maxY, self.view.frame.size.width, 500);
    view.selectArr = selectArr;
    view.unSelectArr = unSelectArr;
    view.alignment = SHLayoutAlignment_left;
    [view reloadView];

    view.block = ^(SHTagView * _Nonnull tag) {
        [self.switchBtn setOn:tag.isEdit animated:YES];
        if (!tag.isEdit) {
            NSLog(@"选中--%@",tag.selectArr);
            NSLog(@"未选中--%@",tag.unSelectArr);
            NSLog(@"选中位置--%ld",(long)tag.currentIndex);
        }
    };
    self.tagView = view;
    [bgView addSubview:view];
    
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
}

- (IBAction)switchAction:(UISwitch *)sender {
    self.tagView.isEdit = sender.isOn;
}

@end
