//
//  GridView.m
//  hacfun
//
//  Created by Ben on 15/12/5.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "GridView.h"
#import "FuncDefine.h"

@interface GridView () {
    CGSize _size;
    CGSize _sizeFitCell;
    NSInteger _number;
    
    NSMutableArray *_cellViews;
}

#define TAG_Offset (45000000)

@end





@implementation GridView


- (id)init {
    
    if(self = [super init]) {
        self.aspectRatio = 2.0;
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _size = frame.size;
    
    self.aspectRatio = 3.0;
    
    //self.contentSize = CGSizeMake(frame.size.width, frame.size.height * 10);
    
    return self;
}


//#define LOG_VIEW_RECT(v, name) { CGRect frame = v.frame; NSLog(@"%s %d : x:%lf, y:%lf, w:%lf, h:%lf ------[%@]", __FUNCTION__, __LINE__, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height, name); }
- (void)addCellView:(UIView*)cellView {
    
    //add as fitwidht.
    _sizeFitCell.width = (_size.width - self.leftBorder - self.rightBorder - (self.numberInLine - 1) * self.HirizonBorder) / self.numberInLine;
    _sizeFitCell.height = _sizeFitCell.width / self.aspectRatio ;
    NS0Log(@"width : %f, height:%f, aspectRatio : %f", _sizeFitCell.width, _sizeFitCell.height, self.aspectRatio);
    
    float xCell = self.leftBorder + (_number % self.numberInLine) * (self.HirizonBorder + _sizeFitCell.width);
    float yCell = self.topBorder + (_number / self.numberInLine) * (self.viticalBorder + _sizeFitCell.height);
    
    [cellView setFrame:CGRectMake(xCell, yCell, _sizeFitCell.width, _sizeFitCell.height)];
    LOG_VIEW_REC0(cellView, @"")
    [cellView setTag:_number+TAG_Offset];
    [self addSubview:cellView];
    
    _number ++;
   
    NSInteger lines = (_number + (self.numberInLine - 1)) / self.numberInLine ;
    //不用增加1行. 可是不增加的话最后一行显示不出来. 
    lines ++;
    self.contentSize = CGSizeMake(_size.width, _sizeFitCell.height * lines);
}


- (NSInteger)numberOfCells {
    return _number;
}


- (UIView*)cellViewAt:(NSInteger)index {
    return [self viewWithTag:index+TAG_Offset];
}



@end
