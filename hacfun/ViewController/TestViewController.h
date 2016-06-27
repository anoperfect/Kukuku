//
//  TestViewController.h
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "CustomViewController.h"

@interface TestViewController : CustomViewController





@end


@interface EULAView : UIView
- (instancetype)initWithFrame:(CGRect)frame withAgreement:(BOOL)withAgreement andUserFeedbackHanle:(void(^)(BOOL isUserAgree, BOOL notShowAgain))userFeedbackHanle;

@end
