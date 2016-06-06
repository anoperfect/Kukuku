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
#import "PushButton.h"
@interface EmoticonCharacterView () {
    
    NSArray *_EmoticonStrings;
    
};
@property (nonatomic, strong) GridView *buttonsGridView;

@end


@implementation EmoticonCharacterView

- (NSArray*)getEmoticonStrings {

    NSArray *emoticons = [[AppConfig sharedConfigDB] configDBEmoticonGet];
    NSMutableArray *stringsM = [[NSMutableArray alloc] init];
    for(Emoticon *emoticon in emoticons) {
        [stringsM addObject:emoticon.emoticon];
    }
    
    return [NSArray arrayWithArray:stringsM];
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
    [self.buttonsGridView removeFromSuperview];
    
    _EmoticonStrings = [self getEmoticonStrings];
    NSInteger num = [_EmoticonStrings count];
    
    CGRect frame = self.frame;
    LOG_RECT(frame, @"emoticonview")
    
    self.buttonsGridView = [[GridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.buttonsGridView.numberInLine = self.frame.size.width / 80;
    [self addSubview:self.buttonsGridView];
    
    for(NSInteger i = 0; i<num; i++) {
        PushButton *button = [[PushButton alloc] init];
        [button setTitle:[_EmoticonStrings objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [button.layer setBorderWidth:0.5];

        [button.layer setBorderColor:[UIColor colorWithName:@"CreateEmoticonButtonBorder"].CGColor];
        [self.buttonsGridView addCellView:button];
        button.adjustsImageWhenHighlighted = YES;
        button.showsTouchWhenHighlighted = YES;
    }
}


- (void)emoticonsHidden
{
    self.isShow = NO;
    //移除前一个grid.
    [self.buttonsGridView removeFromSuperview];
    self.buttonsGridView = nil;
}


- (void)setInputAction:(inputAction)action {
    _action = action;
}


- (void)buttonClick:(PushButton*)button {
    NSString *title = [button titleForState:UIControlStateNormal];
    if(self.action) {
        self.action(title);
    }
}

@end
