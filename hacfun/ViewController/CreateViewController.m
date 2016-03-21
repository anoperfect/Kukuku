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
#import "FrameLayout.h"
#import "PercentageLayout.h"


#define TAG_CONTENT_VIEW    1000
#define TAG_TEXTVIEW        100001
#define TAG_ACTION_VIEW     100002


@interface CreateViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UITextView              * _textView;
    UIView                  * _viewAttachPicture;
    UIImageView             * _imageView;
    UIButton                * _postImageRemoveButton;
    UIButton                * _emoticonButton;
    UIButton                * _captureButton;
    UIButton                * _photoLibraryButton;
    UIButton                * _sendButton;
    EmoticonCharacterView   * _emoticonView;
    
    NSData                  * _imageDataPost;
    NSMutableDictionary     * _dictConnectionData;

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
    
    // 延时加载UITextView, 否则可能产生不流畅现象.
    
#if 0
    /* 颜文字, 图片, 发送按钮. */
    _actionsContainerView = [[UIView alloc] init];
    [self.view addSubview:_actionsContainerView];
    [self setActionButtons];
    LAYOUT_BORDER_ORANGE(_actionsContainerView)
#endif
    
    /* 图片附件. */
    _viewAttachPicture = [[UIView alloc] init];
    [self.view addSubview:_viewAttachPicture];
    _viewAttachPicture.backgroundColor  = [UIColor blueColor];
    _viewAttachPicture.tag              = (NSInteger)@"ImageAttachView";
    
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    _imageView.tag = (NSInteger)@"ImageView";
    
    _postImageRemoveButton = [[UIButton alloc] init];
    [self.view addSubview:_postImageRemoveButton];
    _postImageRemoveButton.tag = 10;
    [_postImageRemoveButton addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchDown];
    [_postImageRemoveButton setTitle:@"X" forState:UIControlStateNormal];
    
    _emoticonButton = [[UIButton alloc] init];
    [self.view addSubview:_emoticonButton];
    [_emoticonButton addTarget:self action:@selector(emoticon) forControlEvents:UIControlEventTouchDown];
    [_emoticonButton setImage:[UIImage imageNamed:@"emoticon"] forState:UIControlStateNormal];
    
    _captureButton = [[UIButton alloc] init];
    [self.view addSubview:_captureButton];
    [_captureButton addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchDown];
    [_captureButton setImage:[UIImage imageNamed:@"capture"] forState:UIControlStateNormal];
    
    _photoLibraryButton = [[UIButton alloc] init];
    [self.view addSubview:_photoLibraryButton];
    [_photoLibraryButton addTarget:self action:@selector(photoLibrary) forControlEvents:UIControlEventTouchDown];
    [_photoLibraryButton setImage:[UIImage imageNamed:@"photolibrary"] forState:UIControlStateNormal];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_sendButton];
    
    // 颜文字.
    // 颜文字优化有问题. 一开始便创建所有颜文字冤死的话会卡顿. 修改为点击图标后显示.
    _emoticonView = [[EmoticonCharacterView alloc] init];
    [self.view addSubview:_emoticonView];
    _emoticonView.tag = 2;
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
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.frame.size];
    if(!CGRectIsEmpty(self.frameSoftKeyboard)) {
        NSLog(@"got softkeyboard frame.[showing : %d]", self.isShowingSoftKeyboard);
        [layout setUseIncludedMode:@"Emoticon" includedTo:NAME_MAIN_FRAME withPostion:FrameLayoutPositionBottom andSizeValue:self.frameSoftKeyboard.size.height];
    }
    else {
        NSLog(@"not got softkeyboard frame.");
        [layout setUseIncludedMode:@"Emoticon" includedTo:NAME_MAIN_FRAME withPostion:FrameLayoutPositionBottom andSizePercentage:0.4];
    }
    
    CGFloat heightActionButtons = 36;
    CGFloat widthActionButtons = heightActionButtons * 1.5;
    [layout setUseBesideMode:@"Action" besideTo:@"Emoticon" withDirection:FrameLayoutDirectionAbove andSizeValue:heightActionButtons];
    [layout setUseIncludedMode:@"EmoticonButton" includedTo:@"Action" withPostion:FrameLayoutPositionLeft andSizeValue:widthActionButtons];
    [layout setUseBesideMode:@"CaptureButton" besideTo:@"EmoticonButton" withDirection:FrameLayoutDirectionRigth andSizeValue:widthActionButtons];
    [layout setUseBesideMode:@"PhotoLibraryButton" besideTo:@"CaptureButton" withDirection:FrameLayoutDirectionRigth andSizeValue:widthActionButtons];
    CGFloat widthSendButton = 60;
    [layout setUseIncludedMode:@"SendButton" includedTo:@"Action" withPostion:FrameLayoutPositionRight andSizeValue:widthSendButton];
    
    [layout setUseLeftMode:@"InputAll" standardTo:@"Action" withDirection:FrameLayoutDirectionAbove];
    if(_imageDataPost) {
        [layout divideInHerizon:@"InputAll" to:@"TextView" and:@"ViewAttachPicture" withPercentage:0.8];
        CGRect frameViewAttachPicture = [layout getCGRect:@"ViewAttachPicture"];
        [layout setUseIncludedMode:@"ImageView" includedTo:@"ViewAttachPicture" withPostion:FrameLayoutPositionLeft andSizeValue:frameViewAttachPicture.size.height];
        [layout setUseIncludedMode:@"PostImageRemoveButton" includedTo:@"ViewAttachPicture" withPostion:FrameLayoutPositionRight andSizeValue:frameViewAttachPicture.size.height];
    }
    else {
        [layout divideInHerizon:@"InputAll" to:@"TextView" and:@"ViewAttachPicture" withPercentage:1.0];
        [layout setCGRect:CGRectZero toName:@"ImageView"];
        [layout setCGRect:CGRectZero toName:@"PostImageRemoveButton"];
    }
    
    [_textView              setFrame:[layout getCGRect:@"TextView"]];
//    [_viewAttachPicture     setFrame:[layout getCGRect:@"ViewAttachPicture"]];
    [_imageView             setFrame:[layout getCGRect:@"ImageView"]];
    [_postImageRemoveButton setFrame:[layout getCGRect:@"PostImageRemoveButton"]];
//    [_actionsContainerView  setFrame:[layout getCGRect:@"Action"]];
    [_emoticonButton        setFrame:[layout getCGRect:@"EmoticonButton"]];
    [_captureButton         setFrame:[layout getCGRect:@"CaptureButton"]];
    [_photoLibraryButton    setFrame:[layout getCGRect:@"PhotoLibraryButton"]];
    [_sendButton            setFrame:[layout getCGRect:@"SendButton"]];
    
    [_emoticonView          setFrame:[layout getCGRect:@"Emoticon"]];
    
    CGSize sizeButtons = _emoticonButton.frame.size;
    CGFloat leftEdge = (sizeButtons.width - sizeButtons.height ) / 2  + 1;
    UIEdgeInsets actionsButtonEdge = UIEdgeInsetsMake(1, leftEdge, 1, leftEdge);
    [_emoticonButton        setImageEdgeInsets:actionsButtonEdge];
    [_captureButton         setImageEdgeInsets:actionsButtonEdge];
    [_photoLibraryButton    setImageEdgeInsets:actionsButtonEdge];
    
    LOG_VIEW_RECT(_textView, @"textView")
    LOG_VIEW_RECT(_viewAttachPicture, @"_viewAttachPicture")
    LOG_VIEW_RECT(_actionsContainerView, @"_actionsContainerView")
    
//    [self layoutSubviewActions];
    //[self layoutSubviewAttachPicture];
    
    NSLog(@"%@", layout);
}



- (void)viewDidAppear:(BOOL)animated
{
    if(nil == _textView) {
        _textView = [[UITextView alloc] init];
        [self.view addSubview:_textView];
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
    [_textView becomeFirstResponder];
}


- (void)notFocusToInput
{
    [_textView resignFirstResponder];
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
    
    //选择后即回到编辑状态.
    [_emoticonView emoticonsHidden];
    [self focusToInput];
}


- (void)emoticon {
    if([_emoticonView isShow]) {
        [self focusToInput];
        [_emoticonView emoticonsHidden];
    }
    else {
        [self notFocusToInput];
        [_emoticonView emoticonsShow];
    }
}


- (void)capture {
    LOG_POSTION
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:^{}];
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self updatePostImage:image];
}


- (void)updatePostImage:(UIImage*)image
{
    [_imageView setContentMode:(UIViewContentModeScaleAspectFit)];
    //    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setImage:image];
    
    //    imageDataPost = UIImagePNGRepresentation(image);
    _imageDataPost = UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"imageData length : %zi", [_imageDataPost length]);
    
    [self focusToInput];
}


- (void)removeImage {
    [_imageView setImage:nil];
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
    [self notFocusToInput];
    
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
    [dic setObject:@"" forKey:@"email"]; //莫拉岛民的平均值.
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
        [self focusToInput];
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






















