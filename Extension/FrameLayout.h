//
//  FrameLayout.h
//  Layout
//
//  Created by Ben on 16/3/17.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FrameLayout : NSObject



#define FRAMELAYOUT_NAME_MAIN @"MainFrame"
- (instancetype)initWithSize:(CGSize)sizeSuper;

- (void)setCGRect:(CGRect)frame toName:(NSString*)name;
- (CGRect)getCGRect:(NSString*)name;


typedef NS_ENUM(NSInteger, FrameLayoutOrientation) {
    FrameLayoutOrientationHorizon,
    FrameLayoutOrientationVertical
};


typedef NS_ENUM(NSInteger, FrameLayoutDirection) {
    FrameLayoutDirectionHorizon,
    FrameLayoutDirectionVertical,
    FrameLayoutDirectionAbove,
    FrameLayoutDirectionBelow,
    FrameLayoutDirectionLeft,
    FrameLayoutDirectionRigth,
    FrameLayoutDirectionLeftAbove,
    FrameLayoutDirectionLeftBelow,
    FrameLayoutDirectionRigthAbove,
    FrameLayoutDirectionReighBelow,
};


typedef NS_ENUM(NSInteger, FrameLayoutPosition) {
    FrameLayoutPositionTop,
    FrameLayoutPositionBottom,
    FrameLayoutPositionLeft,
    FrameLayoutPositionRight
};


- (CGRect)setUseEdge:(NSString*)name
                  in:(NSString*)inName
       withEdgeValue:(UIEdgeInsets)edge;


- (void)divideInHerizon:(NSString*)inName
                     to:(NSString*)name1
                    and:(NSString*)name2
         withPercentage:(CGFloat)percentage;

- (void)divideInHerizon:(NSString*)inName
                     to:(NSString*)name1
                    and:(NSString*)name2
        withHeightValue:(CGFloat)height;

- (void)divideInVertical:(NSString*)inName
                      to:(NSString*)name1
                     and:(NSString*)name2
          withPercentage:(CGFloat)percentage;

- (void)divideInVertical:(NSString*)inName
                      to:(NSString*)name1
                     and:(NSString*)name2
          withWidthValue:(CGFloat)width;



- (void)arrangeInHerizonIn:(NSString*)inName
                        to:(NSArray<NSString*> *)names
     withPercentageHeights:(NSArray<NSNumber *> *)percentageHeights;

- (void)arrangeInHerizonIn:(NSString*)inName
                        to:(NSArray<NSString*> *)names
               withHeights:(NSArray<NSNumber *> *)heights;


- (void)arrangeInVerticalIn:(NSString*)inName
                         to:(NSArray<NSString*> *)names
       withPercentageWidths:(NSArray<NSNumber *> *)percentageWidths;

- (void)arrangeInVerticalIn:(NSString*)inName
                         to:(NSArray<NSString*> *)names
                 withWidths:(NSArray<NSNumber *> *)widths;



- (void)arrangeInHerizonIn:(NSString*)inName toNameAndPercentageHeights:(NSArray<NSDictionary*> *)nameAndPercentageHeights;




//Beside mode.
- (CGRect)setUseBesideMode:(NSString*)name
                  besideTo:(NSString*)toName
             withDirection:(FrameLayoutDirection)direction
              andSizeValue:(CGFloat)value;

- (CGRect)setUseBesideMode:(NSString*)name
                  besideTo:(NSString*)toName
             withDirection:(FrameLayoutDirection)direction
         andSizePersentage:(CGFloat)percentage;



//Left mode.
- (CGRect)setUseLeftMode:(NSString*)name
              standardTo:(NSString*)toName
           withDirection:(FrameLayoutDirection)direction;



//Included mode.
- (CGRect)setUseIncludedMode:(NSString*)name
                  includedTo:(NSString*)toName
                 withPostion:(FrameLayoutPosition)postion
                andSizeValue:(CGFloat)value;

- (CGRect)setUseIncludedMode:(NSString*)name
                  includedTo:(NSString*)toName
                 withPostion:(FrameLayoutPosition)postion
           andSizePercentage:(CGFloat)percentage;



//divide eqully.
- (void)setDivideEquallyInHerizon:(NSString *)inName
                       withNumber:(NSInteger)number
                               to:(NSArray*)names;

- (void)setDivideEquallyInVertical:(NSString *)inName
                        withNumber:(NSInteger)number
                                to:(NSArray*)names;


//offset.
- (void)setOffset:(NSString*)name dx:(CGFloat)dx dy:(CGFloat)dy;



+ (void)setViewToCenter:(UIView *)view;


+ (CGRect)narrow:(CGSize)size inContainer:(CGRect)rectContainer withBroaden:(BOOL)broaden center:(BOOL)center;

@end















































//CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//LOG_RECT(applicationFrame, @"applicationFrame")

//CGRect bounds = [[UIScreen mainScreen] bounds];
//LOG_RECT(bounds, @"bounds")

//判断竖屏横屏.
#define VERTIVAL_SCREEN ([[UIScreen mainScreen] bounds].size.height >= [[UIScreen mainScreen] bounds].size.width)












#define FRAMELAYOUT_Y_BLOW_FRAME(frame) (frame.origin.y + frame.size.height)





#define FRAMELAYOUT_SET_HEIGHT(view, setHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , setHeight)]; }
#define FRAMELAYOUT_ADD_HEIGHT(view, addHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , frame.size.height + addHeight)]; }



#define FRAMELAYOUT_IS_EQUAL(frameqwe, frameqwr) ([[NSValue valueWithCGRect:frameqwe] isEqualToValue:[NSValue valueWithCGRect:frameqwr]])