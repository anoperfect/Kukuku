//
//  FrameLayout.m
//  Layout
//
//  Created by Ben on 16/3/17.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "FrameLayout.h"






@interface FrameLayout ()

@property (nonatomic, assign) CGSize sizeSuper;

@property (nonatomic, strong) NSMutableDictionary *frames;


@end


@implementation FrameLayout




- (instancetype)initWithSize:(CGSize)sizeSuper
{
    self = [super init];
    if(nil != self) {
        self.sizeSuper = sizeSuper;
        self.frames = [[NSMutableDictionary alloc] init];
        [self.frames setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, sizeSuper.width, sizeSuper.height)] forKey:NAME_MAIN_FRAME];
    }
    
    return self;
}


- (void)setCGRect:(CGRect)frame toName:(NSString*)name
{
    [self.frames setValue:[NSValue valueWithCGRect:frame] forKey:name];
}


- (CGRect)getCGRect:(NSString*)name
{
    CGRect frame = CGRectZero;
    
    NSValue *frameValue = [self.frames valueForKey:name];
    if(nil != frameValue) {
        frame = [frameValue CGRectValue];
    }
    
    return frame;
}


- (CGRect)setUseEdge:(NSString *)name
                  in:(NSString *)inName
       withEdgeValue:(UIEdgeInsets)edge
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame = inFrame;
    frame.origin.x      += (edge.left);
    frame.origin.y      += (edge.top);
    frame.size.width    -= (edge.left + edge.right);
    frame.size.height   -= (edge.top + edge.bottom);
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (CGRect)setWithLine:(NSString*)name
                   in:(NSString*)inName
           withHeight:(CGFloat)height
                 andY:(CGFloat)y
              andEdge:(UIEdgeInsets)edge
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame = inFrame;
    frame.origin.x      += (edge.left);
    frame.origin.y      += (edge.top + y);
    frame.size.width    -= (edge.left + edge.right);
    frame.size.height   = height;
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (CGRect)setWithRow:(NSString*)name
                  in:(NSString*)inName
           withWidth:(CGFloat)width
                andX:(CGFloat)x
             andEdge:(UIEdgeInsets)edge
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame = inFrame;
    frame.origin.x      += (edge.left + x);
    frame.origin.y      += (edge.top);
    frame.size.width    =  (width);
    frame.size.height   -= (edge.top + edge.bottom);
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (void)divideInHerizon:(NSString*)inName
                     to:(NSString*)name1
                    and:(NSString*)name2
         withPercentage:(CGFloat)percentage
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame1 = inFrame;
    frame1.size.height = inFrame.size.height * percentage;
    [self setCGRect:frame1 toName:name1];
    
    CGRect frame2 = inFrame;
    frame2.origin.y += frame1.size.height;
    frame2.size.height = inFrame.size.height * (1 - percentage);
    [self setCGRect:frame2 toName:name2];
}


- (void)divideInHerizon:(NSString*)inName
                     to:(NSString*)name1
                    and:(NSString*)name2
        withHeightValue:(CGFloat)height
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame1 = inFrame;
    frame1.size.height = height;
    [self setCGRect:frame1 toName:name1];
    
    CGRect frame2 = inFrame;
    frame2.origin.y += frame1.size.height;
    frame2.size.height = inFrame.size.height - height;
    [self setCGRect:frame2 toName:name2];
}


- (void)divideInVertical:(NSString*)inName
                      to:(NSString*)name1
                     and:(NSString*)name2
          withPercentage:(CGFloat)percentage
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame1 = inFrame;
    frame1.size.width = inFrame.size.width * percentage;
    [self setCGRect:frame1 toName:name1];
    
    CGRect frame2 = inFrame;
    frame2.origin.x += frame1.size.width;
    frame2.size.width = inFrame.size.width * (1 - percentage);
    [self setCGRect:frame2 toName:name2];
}


- (void)divideInVertical:(NSString*)inName
                      to:(NSString*)name1
                     and:(NSString*)name2
          withWidthValue:(CGFloat)width
{
    CGRect inFrame = [self getCGRect:inName];
    CGRect frame1 = inFrame;
    frame1.size.width = width;
    [self setCGRect:frame1 toName:name1];
    
    CGRect frame2 = inFrame;
    frame2.origin.x += frame1.size.width;
    frame2.size.width = inFrame.size.width - width;
    [self setCGRect:frame2 toName:name2];
}


//Beside mode.
#if 0
- (CGRect)setUsingBesideMode:(NSString*)name aboveTo:(NSString*)toName withHeightValue:(CGFloat)height
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionAbove
             withSizeValue:height];
}


- (CGRect)setUsingBesideMode:(NSString*)name belowTo:(NSString*)toName withHeightValue:(CGFloat)height
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionBelow
             withSizeValue:height];
}


- (CGRect)setUsingBesideMode:(NSString*)name leftTo:(NSString*)toName withHeightValue:(CGFloat)width
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionLeft
             withSizeValue:width];
}


- (CGRect)setUsingBesideMode:(NSString*)name rightTo:(NSString*)toName withHeightValue:(CGFloat)width
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionRigth
             withSizeValue:width];
}


- (CGRect)setUsingBesideMode:(NSString*)name aboveTo:(NSString*)toName withHeightPercentage:(CGFloat)percentage
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionAbove
             withSizePersentage:percentage];
}


- (CGRect)setUsingBesideMode:(NSString*)name belowTo:(NSString*)toName withHeightPercentage:(CGFloat)percentage
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionBelow
        withSizePersentage:percentage];
}


- (CGRect)setUsingBesideMode:(NSString*)name leftTo:(NSString*)toName withWidthPercentage:(CGFloat)percentage
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionLeft
        withSizePersentage:percentage];
}


- (CGRect)setUsingBesideMode:(NSString*)name rightTo:(NSString*)toName withWidthPercentage:(CGFloat)percentage
{
    return
    [self setUseBesideMode:name
                  besideTo:toName
             withDirection:FrameLayoutDirectionRigth
        withSizePersentage:percentage];
}
#endif


- (CGRect)setUseBesideMode:(NSString*)name
                  besideTo:(NSString*)toName
             withDirection:(FrameLayoutDirection)direction
              andSizeValue:(CGFloat)value
{
    CGRect toFrame = [self getCGRect:toName];
    CGRect frame = toFrame;
    switch (direction) {
        case FrameLayoutDirectionAbove:
            frame.origin.y -= value;
            frame.size.height = value;
            break;
            
        case FrameLayoutDirectionBelow:
            frame.origin.y += frame.size.height;
            frame.size.height = value;
            break;
            
        case FrameLayoutDirectionLeft:
            frame.origin.x -= value;
            frame.size.width = value;
            break;
            
        case FrameLayoutDirectionRigth:
            frame.origin.x += frame.size.width;
            frame.size.width = value;
            break;
            
        default:
            NSLog(@"#error - not expected default value.");
    }
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (CGRect)setUseBesideMode:(NSString*)name
                  besideTo:(NSString*)toName
             withDirection:(FrameLayoutDirection)direction
         andSizePersentage:(CGFloat)percentage
{
    CGRect toFrame = [self getCGRect:toName];
    CGRect frame = toFrame;
    CGFloat value;
    switch (direction) {
        case FrameLayoutDirectionAbove:
            value = frame.size.height * percentage;
            frame.origin.y -= value;
            frame.size.height = value;
            break;
            
        case FrameLayoutDirectionBelow:
            value = frame.size.height * percentage;
            frame.origin.y += frame.size.height;
            frame.size.height = value;
            break;
            
        case FrameLayoutDirectionLeft:
            value = frame.size.width * percentage;
            frame.origin.x -= value;
            frame.size.width = value;
            break;
            
        case FrameLayoutDirectionRigth:
            value = frame.size.width * percentage;
            frame.origin.x += frame.size.width;
            frame.size.width = value;
            break;
            
        default:
            NSLog(@"#error - not expected default value.");
            break;
    }
    
    [self setCGRect:frame toName:name];
    return frame;
}


//Left mode.
- (CGRect)setUseLeftMode:(NSString*)name
              standardTo:(NSString*)toName
           withDirection:(FrameLayoutDirection)direction
{
    CGRect toFrame      = [self getCGRect:toName];
    CGRect frame        = toFrame;
    CGSize sizeTotal    = self.sizeSuper;

    switch (direction) {
        case FrameLayoutDirectionAbove:
            frame.origin.y = 0;
            frame.size.height = toFrame.origin.y;
            break;
            
        case FrameLayoutDirectionBelow:
            frame.origin.y += toFrame.size.height;
            frame.size.height = sizeTotal.height - (toFrame.origin.y + toFrame.size.height);
            break;
            
        case FrameLayoutDirectionLeft:
            frame.origin.x = 0;
            frame.size.width = toFrame.origin.x;
            break;
            
        case FrameLayoutDirectionRigth:
            frame.origin.x += toFrame.size.width;
            frame.size.width = sizeTotal.width - (toFrame.origin.x + toFrame.size.width);
            break;
            
        case FrameLayoutDirectionLeftAbove:
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame.size.width = toFrame.origin.x;
            frame.size.height = toFrame.origin.y;
            break;
            
        case FrameLayoutDirectionLeftBelow:
            frame.origin.x = 0;
            frame.origin.y += frame.size.height;
            frame.size.width = toFrame.origin.x;
            frame.size.height = sizeTotal.height - (toFrame.origin.y + toFrame.size.height);
            break;
            
        case FrameLayoutDirectionRigthAbove:
            frame.origin.x += toFrame.size.width;
            frame.origin.y = 0;
            frame.size.width = sizeTotal.width - (toFrame.origin.x + toFrame.size.width);
            frame.size.height = toFrame.origin.y;
            break;
            
        case FrameLayoutDirectionReighBelow:
            frame.origin.x += toFrame.size.width;
            frame.origin.y += toFrame.size.height;
            frame.size.width = sizeTotal.width - (toFrame.origin.x + toFrame.size.width);
            frame.size.height = sizeTotal.height - (toFrame.origin.y + toFrame.size.height);
            break;
            
        default:
            NSLog(@"#error - not expected default value.");
            break;
    }
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (CGRect)setUseIncludedMode:(NSString*)name
                  includedTo:(NSString*)toName
                 withPostion:(FrameLayoutPosition)postion
                andSizeValue:(CGFloat)value
{
    CGRect toFrame = [self getCGRect:toName];
    CGRect frame = toFrame;
    switch (postion) {
        case FrameLayoutPositionTop:
            frame.size.height = value;
            break;
            
        case FrameLayoutPositionBottom:
            frame.origin.y = frame.size.height - value;
            frame.size.height = value;
            break;
            
        case FrameLayoutPositionLeft:
            frame.size.width = value;
            break;
            
        case FrameLayoutPositionRight:
            frame.origin.x = frame.size.width - value;
            frame.size.width = value;
            break;
            
        default:
            NSLog(@"#error - not expected default value.");
            break;
    }
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (CGRect)setUseIncludedMode:(NSString*)name
                  includedTo:(NSString*)toName
                 withPostion:(FrameLayoutPosition)postion
           andSizePercentage:(CGFloat)percentage
{
    CGRect toFrame = [self getCGRect:toName];
    CGRect frame = toFrame;
    CGFloat value;
    switch (postion) {
        case FrameLayoutPositionTop:
            value = toFrame.size.height * percentage;
            frame.size.height = value;
            break;
            
        case FrameLayoutPositionBottom:
            value = toFrame.size.height * percentage;;
            frame.origin.y = toFrame.size.height - value;
            frame.size.height = value;
            break;
            
        case FrameLayoutPositionLeft:
            value = toFrame.size.width * percentage;;
            frame.size.width = value;
            break;
            
        case FrameLayoutPositionRight:
            value = toFrame.size.width * percentage;;
            frame.origin.x = toFrame.size.width - value;
            frame.size.width = value;
            break;
            
        default:
            NSLog(@"#error - not expected default value.");
            break;
    }
    
    [self setCGRect:frame toName:name];
    return frame;
}


- (void)setDivideEquallyInHerizon:(NSString *)inName
                     withNumber:(NSInteger)number
                             to:(NSArray*)names
{
    if(!(number > 0 && [names count] == number)) {
        NSLog(@"#error. invalid number or names.");
        return;
    }
    
    CGRect inFrame = [self getCGRect:inName];
    
    CGRect framex = inFrame;
    framex.size.height = inFrame.size.height / number;
    
    CGFloat dy = 0;
    for(NSInteger index = 0; index < number; index ++) {
        [self setCGRect:CGRectOffset(framex, 0, dy) toName:names[index]];
        dy += framex.size.height;
    }
}


- (void)setDivideEquallyInVertical:(NSString *)inName
                       withNumber:(NSInteger)number
                               to:(NSArray*)names
{
    if(!(number > 0 && [names count] == number)) {
        NSLog(@"#error. invalid number or names.");
        return;
    }
    
    CGRect inFrame = [self getCGRect:inName];
    
    CGRect framex = inFrame;
    framex.size.width = inFrame.size.width / number;
    
    CGFloat dx = 0;
    for(NSInteger index = 0; index < number; index ++) {
        [self setCGRect:CGRectOffset(framex, dx, 0) toName:names[index]];
        dx += framex.size.width;
    }
}


- (NSString*)description
{
    return [NSString stringWithFormat:@"%@", self.frames];
}















    


























@end
