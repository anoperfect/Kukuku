//
//  FuncDefine.h
//  hacfun
//
//  Created by Ben on 15/7/18.
//  Copyright (c) 2015年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WIDTH_FIT(v, mx) { CGRect frameOriginal = v.frame; CGFloat x = frameOriginal.origin.x; CGFloat width = v.superview.frame.size.width - x - mx ; width = width > 0 ? width : 0; [v setFrame: CGRectMake(x, frameOriginal.origin.y, width, frameOriginal.size.height)]; }



#define X_CENTER(v, mx) { CGRect frameOriginal = v.frame; CGFloat width = v.superview.frame.size.width - 2.0 * mx ; width = width > 0 ? width : 0; [v setFrame: CGRectMake(mx, frameOriginal.origin.y, width, frameOriginal.size.height)]; }


#define HEIGHT_FIT(v, my) { CGRect frameOriginal = v.frame; CGFloat y = frameOriginal.origin.y; CGFloat height = v.superview.frame.size.height - y - my ; height = height > 0 ? height : 0; [v setFrame: CGRectMake(frameOriginal.origin.x, y, frameOriginal.size.width, height)]; }


#define Y_CENTER(v, my) { CGRect frameOriginal = v.frame; CGFloat height = v.superview.frame.size.height - 2.0 * my ; height = height > 0 ? height : 0; [v setFrame: CGRectMake(frameOriginal.origin.x, my, frameOriginal.size.width, height)]; }


//    CGRect frame = [[UIScreen mainScreen] bounds];

#define LOG_VIEW_RECT(v, name) { CGRect frame = v.frame; NSLog(@"x:%lf, y:%lf, w:%lf, h:%lf ------[%@]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height, name); }


#define LOG_VIEW_REC0(v, name) {}
#define NS0Log(x...) {}


#define FRAME_ADD_HEIGHT(view, addHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , frame.size.height + addHeight)]; }

#define FRAME_SET_HEIGHT(view, setHeight) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , setHeight)]; }





#define FRAME_BELOW_TO(view, viewBelowTo, border) { CGRect frame = view.frame; [view setFrame:CGRectMake(frame.origin.x, viewBelowTo.frame.origin.y + viewBelowTo.frame.size.height + border, frame.size.width, frame.size.height)]; }


#define LAYOUT_BORDER_ORANGE(view) { [view.layer setBorderWidth:1]; [view.layer setBorderColor:[UIColor orangeColor].CGColor]; }

#define LAYOUT_BORDER_BLUE(view) { [view.layer setBorderWidth:1]; [view.layer setBorderColor:[UIColor blueColor].CGColor]; }


#define LOG_POSTION NSLog(@"======%s %d", __FUNCTION__, __LINE__);




#define LOG_THREAD {NSLog(@"main thread : %@", [NSThread mainThread]); NSLog(@"curr thread : %@", [NSThread currentThread]);}

@interface FuncDefine : NSObject

@end
