//
//  SHTagViewModel.h
//  Example
//
//  Created by CCSH on 2022/5/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTagViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id obj;
//有默认
@property (nonatomic, assign) CGFloat tagW;

@end

NS_ASSUME_NONNULL_END
