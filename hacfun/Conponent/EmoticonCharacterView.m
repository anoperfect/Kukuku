//
//  EmoticonCharacterView.m
//  hacfun
//
//  Created by Ben on 15/12/3.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import "EmoticonCharacterView.h"
#import "AppConfig.h"
#import "GridView.h"
#import "FuncDefine.h"

@interface EmoticonCharacterView () {
    
    NSArray *_EmoticonStrings;
    
};

@end


@implementation EmoticonCharacterView

- (NSArray*)getEmoticonStrings {
    //NSMutableArray *mutableStrings = [[NSMutableArray alloc] init];
    return [[AppConfig sharedConfigDB] getEmoticonStrings];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        //[self emoticonsShow];
    }
    
    return self;
}


- (void)layoutSubviews {
    LOG_POSTION
    //[self emoticonsShow];
}


- (void)emoticonsShow
{
    self.isShow = YES;
    //移除前一个grid.
    [[self viewWithTag:1] removeFromSuperview];
    
    _EmoticonStrings = [self getEmoticonStrings];
    NSInteger num = [_EmoticonStrings count];
    
    CGRect frame = self.frame;
    LOG_RECT(frame, @"emoticonview")
    
    GridView *buttonsGridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    buttonsGridView.tag = 1;
    buttonsGridView.numberInLine = 4;
    [self addSubview:buttonsGridView];
    
    for(NSInteger i = 0; i<num; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:[_EmoticonStrings objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[UIColor blueColor].CGColor];
        [buttonsGridView addCellView:button];
    }
}


- (void)emoticonsHidden
{
    self.isShow = NO;
    //移除前一个grid.
    [[self viewWithTag:1] removeFromSuperview];
}


- (void)setInputAction:(inputAction)action {
    _action = action;
    
}


- (void)buttonClick:(UIButton*)button {
    NSString *title = [button titleForState:UIControlStateNormal];
    if(self.action) {
        self.action(title);
        [self emoticonsHidden];
    }
}

@end
