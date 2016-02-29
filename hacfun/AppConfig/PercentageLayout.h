//
//  PercentageLayout.h
//  hacfun
//
//  Created by Ben on 15/12/7.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef PERCENTAGELAYOUT_LEFT_BORDER
#define PERCENTAGELAYOUT_LEFT_BORDER 0.0
#endif


#ifndef PERCENTAGELAYOUT_RIGHT_BORDER
#define PERCENTAGELAYOUT_RIGHT_BORDER 0.0
#endif


#ifndef PERCENTAGELAYOUT_TOP
#define PERCENTAGELAYOUT_TOP 0.0
#endif


#define CGRectMakeByPercentageLayoutVertical(superView, topPercentage, heightPercentage) \
CGRectMake(\
           superView.frame.size.width * PERCENTAGELAYOUT_LEFT_BORDER, \
           superView.frame.size.height * (PERCENTAGELAYOUT_TOP + topPercentage),\
           superView.frame.size.width * (1.0 - PERCENTAGELAYOUT_LEFT_BORDER - PERCENTAGELAYOUT_RIGHT_BORDER),\
           superView.frame.size.height * heightPercentage)



#define CGRectMakeByPercentageFrameVertical(frame, topPercentage, heightPercentage) \
CGRectMake(\
           frame.size.width * PERCENTAGELAYOUT_LEFT_BORDER, \
           frame.size.height * (PERCENTAGELAYOUT_TOP + topPercentage),\
           frame.size.width * (1.0 - PERCENTAGELAYOUT_LEFT_BORDER - PERCENTAGELAYOUT_RIGHT_BORDER),\
           frame.size.height * heightPercentage)


@interface PercentageLayout : NSObject

@end
