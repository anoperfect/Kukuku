//
//  GridView.h
//  hacfun
//
//  Created by Ben on 15/12/5.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIScrollView




@property (assign,nonatomic) NSInteger numberInLine;
@property (assign,nonatomic) NSInteger totalNumber;

@property (assign,nonatomic) BOOL fitWidth;
@property (assign,nonatomic) BOOL fitHeight;
@property (assign,nonatomic) float aspectRatio;


@property (assign,nonatomic) float leftBorder ;
@property (assign,nonatomic) float HirizonBorder;
@property (assign,nonatomic) float rightBorder;
@property (assign,nonatomic) float topBorder ;
@property (assign,nonatomic) float viticalBorder;
@property (assign,nonatomic) float bottomBorder;

@property (assign,nonatomic) float cellWidth;
@property (assign,nonatomic) float cellHeight;





- (NSInteger)numberOfCells ;
- (void)addCellView:(UIView*)cellView;
- (UIView*)cellViewAt:(NSInteger)index;

@end



