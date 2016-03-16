//
//  CreateViewController.m
//  hacfun
//
//  Created by Ben on 15/7/28.
//  Copyright (c) 2015年 Ben. All rights reserved.
//
#import "CreateViewController.h"
#import "FuncDefine.h"
#import "AppConfig.h"
#import "PopupView.h"
#import "ButtonData.h"
#import "CookieManage.h"
#import "DetailViewController.h"
#import "CategoryViewController.h"
#import "EmoticonCharacterView.h"

#import "PercentageLayout.h"


#define TAG_CONTENT_VIEW    1000
#define TAG_TEXTVIEW        100001
#define TAG_ACTION_VIEW     100002


@interface CreateViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UIView                  * _viewContent;
    UITextView              * _textView;
    UIButton                * _btnSend;
    EmoticonCharacterView   * _emoticonView;
    UIView                  * _viewAttachPicture;
    UIView                  * _imageView;
    
    NSData                  * _imageDataPost;
    NSMutableDictionary     * _dictConnectionData;
    NSTimer                 * _timerOpenKeypad;

    UIView                  * _actionsContainerView; //放置点击按钮的容器view.
}




@property (strong,nonatomic) NSString *nameCategory;
@property (assign,nonatomic) NSInteger id;
@property (assign,nonatomic) NSInteger idReference;

@property (assign,nonatomic) NSInteger threadsId;

@property (nonatomic, strong) UIView *viewInputContainer;

@end

@implementation CreateViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewContent = [[UIView alloc] init];
    [self.view addSubview:_viewContent];
    [_viewContent setTag:1];
    
    
//    _textView = [[UITextView alloc] init];
//    [_viewContent addSubview:_textView];
//    LAYOUT_BORDER_BLUE(_textView)
//    
//    _textView.delegate = self;
//    _textView.returnKeyType = UIReturnKeyDefault;
//    _textView.keyboardType = UIKeyboardTypeDefault;
//    [self performSelector:@selector(focusToInput) withObject:nil afterDelay:1.0f];
    
    /* 颜文字, 图片, 发送按钮. */
    _actionsContainerView = [[UIView alloc] init];
    [_viewContent addSubview:_actionsContainerView];
    //[self.view addSubview:_actionsContainerView];
    [self setActionButtons];
    LAYOUT_BORDER_ORANGE(_actionsContainerView)
    
    /* 图片附件. */
    _viewAttachPicture = [[UIView alloc] init];
    [_viewContent addSubview:_viewAttachPicture];
    //[_viewAttachPicture setHidden:YES];
    [_viewAttachPicture setBackgroundColor:[UIColor blueColor]];
    [_viewAttachPicture setTag:(NSInteger)@"ImageAttachView"];
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setTag:(NSInteger)@"ImageView"];
    [_viewAttachPicture addSubview:_imageView];
    
    UIButton *button = [[UIButton alloc] init];
    [_viewAttachPicture addSubview:button];
    button.tag = 10;
    [button addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"X" forState:UIControlStateNormal];
    
    // 颜文字.
    // 颜文字优化有问题. 一开始便创建所有颜文字冤死的话会卡顿. 修改为点击图标后显示.
    _emoticonView = [[EmoticonCharacterView alloc] init];
    [self.view addSubview:_emoticonView];
    [_emoticonView setTag:2];
    __block CreateViewController *selfBlock = self;
    [_emoticonView setInputAction:^(NSString *emoticonString){
        [selfBlock inputEmoticon:emoticonString];
    }];
    
    _dictConnectionData = [[NSMutableDictionary alloc] init];
    
    //通知中心.
    //键盘出现时,重置textView高度和btn的高度.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if(0 != self.id) {
        self.textTopic = [NSString stringWithFormat:@"No.%zi", self.id];
    }
    else {
        self.textTopic = [NSString stringWithFormat:@"%@ - 新建", self.nameCategory];
    }
    
    if(self.idReference > 0) {
        _textView.text = [NSString stringWithFormat:@">>No.%zi\n", self.idReference];
    }
    
    
    NSLog(@"finish.")
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect viewFrame = self.view.frame;
    
    CGRect rectContentView = viewFrame;
    CGRect rectTextView = viewFrame;
    CGRect rectViewAttachPicture = viewFrame;
    CGRect rectActionsContainerView = viewFrame;
    rectActionsContainerView.size.height = 36;
    
    //viewContent布局在BannerView和Keyboard间.
    //其他布局在viewContent上.
    rectContentView.origin.y = self.yBolowView;
    
    CGRect frameAll = CGRectMake(0, self.yBolowView, self.view.frame.size.width, self.view.frame.size.height);
    CGRect frameEmoticonView = frameAll;
    
    LOG_RECT(self.view.frame, @"self.view.frame")
    LOG_RECT(frameAll, @"all0")
    
#define RECT_Y_BELOW_FRAME(frame) (frame.origin.y + frame.size.height)
    //如果有记录软键盘的frame, 则设置emoticon的高度与软键盘匹配.
    if(!CGRectIsEmpty(self.frameSoftKeyboard)) {
        NSLog(@"got softkeyboard frame.[showing : %d]", self.isShowingSoftKeyboard);
        frameAll.size.height = self.view.frame.size.height
                                - self.frameSoftKeyboard.size.height;
        frameEmoticonView.size.height = self.frameSoftKeyboard.size.height;
        frameEmoticonView.origin.y = RECT_Y_BELOW_FRAME(frameAll);
    }
    else {
        NSLog(@"not got softkeyboard frame.");
        frameAll.size.height = self.view.frame.size.height;
        frameAll = CGRectMakeByPercentageFrameVertical(frameAll, 0.0, 0.6);
        frameEmoticonView = CGRectMakeByPercentageFrameVertical(frameAll, 0.6, 0.4);
    }
    LOG_RECT(frameAll, @"all1")
    LOG_RECT(frameEmoticonView, @"emoticon")
    
    rectActionsContainerView = frameEmoticonView;
    rectActionsContainerView.origin.y -= 36;
    rectActionsContainerView.size.height = 36;
    LOG_RECT(rectActionsContainerView, @"Actions")
    
    CGRect rectContentLeft = frameAll;
    rectContentLeft.size.height -= 36;
    
    if(_imageDataPost) {
        rectTextView = CGRectMakeByPercentageFrameVertical(rectContentLeft, 0.0, 0.8);
        rectViewAttachPicture = CGRectMakeByPercentageFrameVertical(rectContentLeft, 0.8, 0.2);
    }
    else {
        rectTextView = CGRectMakeByPercentageFrameVertical(rectContentLeft, 0.0, 1.0);
        rectViewAttachPicture = CGRectMakeByPercentageFrameVertical(rectContentLeft, 1.0, 0.0);
    }
    
    [_viewContent setFrame:rectContentView];
    [_textView setFrame:rectTextView];
    [_viewAttachPicture setFrame:rectViewAttachPicture];
    [_actionsContainerView setFrame:rectActionsContainerView];
    [_emoticonView setFrame:frameEmoticonView];

    LOG_RECT(rectContentLeft, @"viewContentLeft")
    LOG_VIEW_RECT(_textView, @"textView")
    LOG_VIEW_RECT(_viewAttachPicture, @"_viewAttachPicture")
    LOG_VIEW_RECT(_actionsContainerView, @"_actionsContainerView")
    
    [self layoutSubviewActions];
    [self layoutSubviewAttachPicture];
    
    //重新布置_imageView,_actionsContainerView subviews.
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewAttachPicture.frame.size.width - _viewAttachPicture.frame.size.height, _viewAttachPicture.frame.size.height)];
    
    NSLog(@"view superView : %@", [self.view superview]);
}


//当 _actionsContainerView调整时, 调整各按钮.
- (void)layoutSubviewActions
{
    float leftBorder = 10.0;
    float leftPadding = 10.0;
    float topBorder = 6.0;
    float height = _actionsContainerView.frame.size.height - 2 * topBorder;
    float width = height;
    CGRect frameButton = CGRectMake(leftBorder, topBorder, width, height);
    NSInteger numberOfInputTypes = 3;
    for(NSInteger index=0; index<numberOfInputTypes; index++) {
        frameButton.origin.x = leftBorder + index * (leftPadding + width);
        [[_actionsContainerView viewWithTag:(10+index)] setFrame:frameButton];
        NSString *s = [NSString stringWithFormat:@"button%zd", index];
        LOG_RECT(frameButton, s)
    }
    
    CGRect frameButtonSend = CGRectMake(_actionsContainerView.frame.size.width - 60, topBorder, 60, height);
    [_btnSend setFrame:frameButtonSend];
}


- (void)layoutSubviewAttachPicture
{
    float height = _viewAttachPicture.frame.size.height;
    float width = height;
    
    CGRect frameImageView = CGRectMake(0, 0, width, height);
    [_imageView setFrame:frameImageView];
    
    CGRect frameButton = CGRectMake(_viewAttachPicture.frame.size.width - width, 0, width, height);
    UIButton *button = (UIButton*)[_viewAttachPicture viewWithTag:10];
    [button setFrame:frameButton];

//重新布置_imageView,_actionsContainerView subviews.
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(


}


- (void)setActionButtons
{
    NSMutableArray *buttonDataArray = [[NSMutableArray alloc] init];
    ButtonData *data ;
    
    data = [[ButtonData alloc] init];
    data.keyword = @"emoticon";
    data.id = 'r';
    data.superId = 0;
    data.image = @"emoticon";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(emoticon);
    [buttonDataArray addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"capture";
    data.id = 'n';
    data.superId = 0;
    data.image = @"capture";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(capture);
    [buttonDataArray addObject:data];
    
    data = [[ButtonData alloc] init];
    data.keyword = @"photolibrary";
    data.id = 'm';
    data.superId = 0;
    data.image = @"photolibrary";
    data.title = @"";
    data.method = 1;
    data.target = self;
    data.sel = @selector(photoLibrary);
    [buttonDataArray addObject:data];
    

    //subview从基数10开始.
    NSInteger index = 10;
    for(ButtonData *data in buttonDataArray) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index ++;
        button.adjustsImageWhenHighlighted = YES;
        [button setContentMode:UIViewContentModeScaleAspectFit];
        
        if(data.method == 1) {
            [button setImage:[UIImage imageNamed:data.image] forState:UIControlStateNormal];
        }
        else {
            [button setTitle:data.title forState:UIControlStateNormal];
        }
        
        [button.titleLabel setFont:[AppConfig fontFor:@"BannerButtonMenu"]];
        [button setTitleColor:[AppConfig textColorFor:@"BannerButtonMenu"] forState:UIControlStateNormal];
        [button addTarget:data.target action:data.sel forControlEvents:UIControlEventTouchDown];
        [_actionsContainerView addSubview:button];
    }
    
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [_btnSend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnSend addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchDown];
    [_actionsContainerView addSubview:_btnSend];
    //[self.view addSubview:_btnSend];
}


- (void)viewDidAppear:(BOOL)animated
{
    if(nil == _textView) {
        _textView = [[UITextView alloc] init];
        [_viewContent addSubview:_textView];
        LAYOUT_BORDER_BLUE(_textView)
        
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.keyboardType = UIKeyboardTypeDefault;
        
        if(self.idReference > 0) {
            _textView.text = [NSString stringWithFormat:@">>No.%zi\n", self.idReference];
        }
    }
    [self performSelector:@selector(focusToInput) withObject:nil afterDelay:0.0f];
}


- (void)focusToInput
{
    //[_timerOpenKeypad invalidate];
    //_timerOpenKeypad = nil;
    
    [_textView becomeFirstResponder];
}


- (void)inputEmoticon:(NSString*)emoticonString
{
    // 需在光标处插入键入内容, 不能直接append.
    // 获得光标所在的位置
    NSRange range = _textView.selectedRange;
    NSUInteger location = range.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = _textView.text;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location], emoticonString, [content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    _textView.text = result;
    
    range.location += emoticonString.length;
    range.length = 0;
    _textView.selectedRange = range;
    
    [_textView becomeFirstResponder];
}


- (void)emoticon {
    if([_emoticonView isShow]) {
        [_textView becomeFirstResponder];
        [_emoticonView emoticonsHidden];
    }
    else {
        [_textView resignFirstResponder];
        [_emoticonView emoticonsShow];
    }
}


- (void)capture {
    LOG_POSTION
}


- (void)photoLibrary {
    LOG_POSTION
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:^{}];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIView *view = [self.view viewWithTag:(NSInteger)@"ImageAttachView"];
    
    if(view) {
        
        
    }
    else {
    

    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *imageView = (UIImageView*)[view viewWithTag:(NSInteger)@"ImageView"];
    [imageView setContentMode:(UIViewContentModeScaleAspectFit)];
//    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [imageView setImage:image];
    
//    imageDataPost = UIImagePNGRepresentation(image);
    _imageDataPost = UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"imageData length : %zi", [_imageDataPost length]);
    
    [_textView becomeFirstResponder];
}


- (void)removeImage {
    
    //输入框恢复原高度.
//    FRAME_SET_HEIGHT(_textView, _textView.frame.size.height * 4 / 3)
    
    //输入图片栏取消.
//    UIView *view = [self.view viewWithTag:(NSInteger)@"ImageAttachView"];
//    [view removeFromSuperview];
    
    UIView *view = [self.view viewWithTag:(NSInteger)@"ImageAttachView"];
    UIImageView *imageView = (UIImageView*)[view viewWithTag:(NSInteger)@"ImageView"];
    [imageView setImage:nil];
    
    _imageDataPost = nil;
    
    [self.view setNeedsLayout];
}


- (void)setCategory:(NSString*)nameCategory
{
    LOG_POSTION
    self.nameCategory = nameCategory;
    self.id = 0;
    self.idReference = 0;
}


- (void)setReplyId:(NSInteger)id
{
    LOG_POSTION
    self.nameCategory = nil;
    self.id = id;
    self.idReference = 0;
}


- (void)setReplyId:(NSInteger)id withReference:(NSInteger)idReference
{
    LOG_POSTION
    self.nameCategory = nil;
    self.id = id;
    self.idReference = idReference;
}


- (void)notifyDetailViewControllerReload {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateReplyFinish" object:self userInfo:@{@"no":[NSNumber numberWithInteger:111]}];
}


- (void)actionDismissWithReloadNotification:(BOOL)bSendNotification {
    if(bSendNotification) {
        [self notifyDetailViewControllerReload];
    }
    
    //[self dismissViewControllerAnimated:NO completion:^{ }];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)finishTest {
    
    PopupView *popupView = [[PopupView alloc] init];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    popupView.titleLabel = @"测试";
            
    popupView.finish = ^(void) {
                    [self actionDismissWithReloadNotification:YES];
                    
                    DetailViewController *vc = [[DetailViewController alloc]init];
                    [vc setPostThreadId:6670627];
                    
                    //[self presentViewController:vc animated:NO completion:^(void){ }];
                    [self.navigationController pushViewController:vc animated:YES];
                };
    [popupView popupInSuperView:self.view];
    
    return ;
}


- (void)keyboardChangeFrame:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGRect softKeyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    LOG_RECT(softKeyboardFrame, @"softKeyboardFrame")
    
    //判断软键盘是否隐藏.
    //if(self.frameKeyboard.origin.y >= self.view.frame.size.height ) {
    if(!CGRectIntersectsRect(softKeyboardFrame, self.view.frame)) {
        NSLog(@"soft keypad not shown.");
        self.isShowingSoftKeyboard = NO;
    }
    else {
        NSLog(@"soft keypad shown.");
        self.isShowingSoftKeyboard = YES;
        self.frameSoftKeyboard = softKeyboardFrame;
    }
    
    [self.view setNeedsLayout];
}


- (void)clickSend {
    
    [_textView resignFirstResponder];
    
    NSString *host = [[AppConfig sharedConfigDB] configDBGet:@"host"];
    NSString *str = nil;
    
    if(self.nameCategory) {
        str =[NSString stringWithFormat:@"%@/%@/create", host, self.nameCategory];
    }
    else {
        str = [NSString stringWithFormat:@"%@/t/%zi/create", host, self.id];
    }
    
    NSURL *url=[[NSURL alloc] initWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    //分界线的标识符
    //    NSString *TWITTERFON_FORM_BOUNDARY = @"----WebKitFormBoundaryJCYFNcctaaOtDHN2";
    NSString *TWITTERFON_FORM_BOUNDARY = @"----WebKitFormBoundary2UCyBQVe8R5PwpHo";
    
    NSString *firstMPboundary=[[NSString alloc]initWithFormat:@"--%@\r\n", TWITTERFON_FORM_BOUNDARY];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"\r\n--%@\r\n", TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"\r\n--%@--\r\n", TWITTERFON_FORM_BOUNDARY];
    //要上传的图片
    //    UIImage *image=[params objectForKey:@"pic"];
    //    //得到图片的data
    //    NSData* data = UIImagePNGRepresentation(image);
    //    //http body的字符串
    NSMutableData *body = [[NSMutableData alloc]init];
    //参数的集合的所有key的集合
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:30];
    [dic setObject:@"" forKey:@"name"];
    [dic setObject:@"sage" forKey:@"email"]; //莫拉岛民的平均值.
    [dic setObject:@"" forKey:@"title"];
    NSString *contentInput = [NSString stringWithFormat:@"客户端测试.[%@]沉的快...", self.nameCategory];
    contentInput = _textView.text;
    [dic setObject:contentInput forKey:@"content"];
    [dic setObject:@"" forKey:@"image"];
    
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    [ary addObject:@"name"];
    [ary addObject:@"email"];
    [ary addObject:@"title"];
    [ary addObject:@"content"];
    [ary addObject:@"image"];
    
    NSInteger idx = 0;
    
    for(id key in ary) {
        NS0Log(@"key : %@    , value : %@", key, [dic objectForKey:key]);
        
        if(0 == idx) {
            NS0Log(@"first boundary");
            [body appendData:[[NSString stringWithFormat:@"%@", firstMPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            [body appendData:[[NSString stringWithFormat:@"%@", MPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        idx ++;
        
        if([(NSString*)key isEqualToString:@"image"]) {
            if(_imageDataPost) {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"1.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                
                //NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                //path = [path stringByAppendingString:@"/1.png"];
                
                NSData *imageData = _imageDataPost;
                
                NSLog(@"imageData : %zi", [imageData length]);
                [body appendData:imageData];
            }
            else {
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"\"\r\nContent-Type: image/jpeg\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            NSString *strContent = (NSString*)[dic objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"%@", strContent] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"%@", endMPboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //声明结束符：--AaB03x--
    //NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:body];
    //将image的data加入
    //    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    //[myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [mutableRequest setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [mutableRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    NSLog(@"content-length : %zi", [myRequestData length]);
    //设置http body
    [mutableRequest setHTTPBody:myRequestData];
    //http method
    [mutableRequest setHTTPMethod:@"POST"];
    
    [[CookieManage sharedCookieManage] showCookie:@"cookie before POST."];
    
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
    
    //NSString *stringRequestData = [[NSString alloc] initWithData:myRequestData encoding:NSUTF8StringEncoding];
    NS0Log(@"%zi\n%@", stringRequestData.length, stringRequestData);
    NS0Log(@"%zi\n%@", stringRequestData.length, myRequestData);
    NS0Log(@"Request : \n\n%@\n\n", stringRequestData);
    
    PopupView *popupView = [[PopupView alloc] init];
    popupView.rectPadding = 10;
    popupView.rectCornerRadius = 2;
    popupView.numofTapToClose = 0;
    popupView.secondsOfAutoClose = 0;
    popupView.titleLabel = @"发送服务器中";
    popupView.borderLabel = 3;
    popupView.line = 3;
    popupView.stringIncrease = @".";
    popupView.secondsOfstringIncrease = 1;
    popupView.finish = ^(void) {
        NSLog(@"-=-=-=%@", self);
        [_textView becomeFirstResponder];
    };
    [popupView setTag:(NSInteger)@"PopupView"];
    [popupView popupInSuperView:self.view];
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@已经接收到响应%@", [NSThread currentThread], response);
    NSLog(@"------\n%@------\n", connection.description);
    
    NSNumber *number = [[NSNumber alloc] initWithUnsignedInteger:(NSInteger)connection];
    NSMutableData *connectionData = [[NSMutableData alloc] init];
    [_dictConnectionData setObject:connectionData forKey:number];
}


- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    NSLog(@"%@已经接收到数据 %@", [NSThread currentThread], data);
    
    NSNumber *number = [[NSNumber alloc] initWithUnsignedInteger:(NSInteger)connection];
    NSMutableData *connectionData = (NSMutableData*)[_dictConnectionData objectForKey:number];
    [connectionData appendData:data];
    
    NSLog(@"1. %@", [[NSString alloc] initWithData:connectionData encoding:NSUTF8StringEncoding]);
}


- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    
    NSNumber *number = [[NSNumber alloc] initWithUnsignedInteger:(NSInteger)connection];
    NSMutableData *connectionData = (NSMutableData*)[_dictConnectionData objectForKey:number];
    NSLog(@"2. %@", [[NSString alloc] initWithData:connectionData encoding:NSUTF8StringEncoding]);
    
    NSData *data = [[NSData alloc] initWithData:connectionData];
    [_dictConnectionData removeObjectForKey:number];
    
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary*)obj;
        NSLog(@"dict : %@", dict);
        NSInteger code = [(NSNumber*)[dict objectForKey:@"code"] integerValue];
        BOOL success = [(NSNumber*)[dict objectForKey:@"success"] boolValue];
        NSInteger threadsId = [(NSNumber*)[dict objectForKey:@"threadsId"] integerValue];
        NSLog(@"%zi, %d, %zi", code, success, threadsId);
        
        if(200 == code && success) {
            NSLog(@"post successfully.");
            self.threadsId = threadsId;
            
            //保存到post纪录.
            popupView.titleLabel = @"发送成功";
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            [array removeLastObject];
            UIViewController *vc = [array lastObject];
            if([vc isKindOfClass:[DetailViewController class]]) {
                NSLog(@"from DetailViewController");
                
                popupView.finish = ^(void) {
                    /* 刷新最后一页,通常可以看到刚发送的回复. */
                    [(DetailViewController*)vc toLastPage];
        
                    [self.navigationController setViewControllers:array animated:YES];
//                    [self actionDismissWithReloadNotification:YES];
                };
            }
            else
            if([vc isKindOfClass:[CategoryViewController class]]) {
                NSLog(@"from CategoryViewController");
                
                popupView.finish = ^(void) {
                    //将当前界面退出加入刚提交成功的页面加入到UINavigationController中.
                    DetailViewController *vc = [[DetailViewController alloc]init];
                    [vc setPostThreadId:self.threadsId];
                    
                    [array addObject:vc];
                    [self.navigationController setViewControllers:array animated:YES];
                };
            }
            else {
                LOG_POSTION
                
            }
        }
        else {
            NSString *msg = (NSString*)[dict objectForKey:@"msg"];
            popupView.titleLabel = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            popupView.titleLabel = msg;
        }
    }
    else {
        NSLog(@"obj [%@] nil or not NSDictionary class", @"JSONObjectWithData");
        popupView.titleLabel = @"发送失败.数据错误或服务器响应异常.";
    }
    
    [[CookieManage sharedCookieManage] showCookie:@"cookie after POST."];
}


- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"%6zd, %6zd, %6zd", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    popupView.titleLabel = [NSString stringWithFormat:@"发送中 - %zd%%", totalBytesWritten * 100 / totalBytesExpectedToWrite];
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"%@数据传输失败,产生错误%s", [NSThread currentThread], __FUNCTION__);
    NSLog(@"error:%@", error);
    
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    popupView.titleLabel = @"数据传输失败";
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






















