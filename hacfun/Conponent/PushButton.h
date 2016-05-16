//
//  PushButton.h
//  hacfun
//
//  Created by Ben on 16/3/31.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonData.h"
@interface PushButton : UIButton




@property (nonatomic, strong) ButtonData*   actionData;



@property (nonatomic, assign) NSInteger     typeLayout;     //图文类型. 单图. 单文. 左图右文. 左文右图. 上图下文. 上文下图.
@property (nonatomic, assign) UIEdgeInsets  edgeImage;      //根据类型, 只取部分参数.
@property (nonatomic, assign) UIEdgeInsets  edgeTitleLabel; //根据类型, 只取部分参数.



@end



@interface ViewContainer : UIView

- (void)horizonLayoutViews:(NSArray<UIView*>*) subviews
                  withEdge:(UIEdgeInsets)edge
            andSubViewEdge:(UIEdgeInsets)subviewEdge;

- (void)verticalLayoutViews:(NSArray<UIView*>*) subviews
                   withEdge:(UIEdgeInsets)edge
             andSubViewEdge:(UIEdgeInsets)subviewEdge;





@end


