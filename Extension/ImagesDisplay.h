//
//  ImagesDisplay.h
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesDisplay : UIView




//设置需显示的image.
- (void)setDisplayedImages:(NSArray*)imageDatas;


//单选模式下点击后执行的动作.
- (void)setDidSelectHandle:(void(^)(NSInteger row))handle;


//设置为多选模式. 非多选模式下, 点击任意的cell将触发selectImageHandle.
- (void)setMuiltSelectMode:(BOOL)isMuiltSelectMode;

//返回多选模式下, 选择的cell序列.
- (NSArray*)getSelectSnInMuiltSelectMode;

@end
