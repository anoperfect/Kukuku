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



#define NAME_MAIN_FRAME @"MainFrame"
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



@end
