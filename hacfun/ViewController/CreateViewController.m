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
#import "ImageViewController.h"


#define TAG_CONTENT_VIEW    1000
#define TAG_TEXTVIEW        100001
#define TAG_ACTION_VIEW     100002


#if 0
@interface PostDataSend : NSObject<NSURLConnectionDelegate>

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *content;



@property (nonatomic, strong) NSString  *imageType;
@property (nonatomic, strong) NSString  *imageName;
@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, strong) void (^responseHandler)(NSURLResponse * response);
@property (nonatomic, strong) void (^progrossHandler)(NSString *status, BOOL continuous) ;
@property (nonatomic, strong) void (^completionHandler)(NSURLResponse *response, NSData *data, NSError *connectionError);

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;

- (void)aysncPostToUrlString:(NSString*)urlString
             responseHandler:(void (^)(NSURLResponse * response))responseHandler
             progrossHandler:(void (^)(NSString *status, BOOL continuous))progrossHandler
           completionHandler:(void (^)(NSURLResponse *response,
                                       NSData *data,
                                       NSError *connectionError))completionHandler;
@end





@implementation PostDataSend

- (void)aysncPostToUrlString:(NSString*)urlString
             responseHandler:(void (^)(NSURLResponse * response))responseHandler
             progrossHandler:(void (^)(NSString *status, BOOL continuous))progrossHandler
           completionHandler:(void (^)(NSURLResponse *response,
                                       NSData *data,
                                       NSError *connectionError))completionHandler
{
    
}


@end
#endif

@interface CreateViewController ()
<UITextViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITextView              * _textView;
    UIView                  * _viewAttachPicture;
    UIImageView             * _imageView;
    PushButton              * _postImageRemoveButton;
    PushButton              * _emoticonButton;
    PushButton              * _captureButton;
    PushButton              * _photoLibraryButton;
    PushButton              * _sendButton;
    EmoticonCharacterView   * _emoticonView;
    
    NSData                  * _imageDataPost;
    NSMutableDictionary     * _dictConnectionData;

    UIView                  * _actionsContainerView; //放置点击按钮的容器view.
}





//@property (strong,nonatomic) NSString *nameCategory; //提交主题贴时的栏目.
@property (strong,nonatomic) NSString *originalContent; //提交主题时的预制内容, 用于举报时.
@property (assign,nonatomic) NSInteger topicTid; //回复的主题id.
//@property (assign,nonatomic) NSInteger idReference; //引用的id.
@property (strong,nonatomic) Category *category;

@property (nonatomic, assign) long long editedAt; //记录开始发送的时间.

@property (assign,nonatomic) NSInteger newCommitedTid; //提交成功后的主题或回复id.


//草稿相关.
@property (nonatomic, strong) UITableView *draftView;

//@property (nonatomic, strong) NSDictionary *draftInfo;
@property (nonatomic, strong) NSArray *drafts;

@property (nonatomic, assign) BOOL isDraftViewShowing;

@property (nonatomic, strong) PostData *dataSend;
@property (nonatomic, strong) UIImage *postImage;


@end

@implementation CreateViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        ButtonData *actionData = nil;
        
        actionData = [[ButtonData alloc] init];
        actionData.keyword      = @"草稿";
        actionData.imageName    = @"draft";
        [self actionAddData:actionData];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 延时加载UITextView, 否则可能产生不流畅现象.
    
    
    /* 图片附件. */
    _viewAttachPicture = [[UIView alloc] init];
    [self.view addSubview:_viewAttachPicture];
    _viewAttachPicture.backgroundColor  = [UIColor colorWithName:@"CreateAttachPictureBackground"];
    _viewAttachPicture.tag              = (NSInteger)@"ImageAttachView";
    
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    _imageView.tag = (NSInteger)@"ImageView";
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];//定义一个手势
    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
    [_imageView addGestureRecognizer:tap];//添加手势到View中
    
    _postImageRemoveButton = [[PushButton alloc] init];
    [self.view addSubview:_postImageRemoveButton];
    _postImageRemoveButton.tag = 10;
    [_postImageRemoveButton addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchDown];
    [_postImageRemoveButton setTitle:@"X" forState:UIControlStateNormal];
    
    _emoticonButton = [[PushButton alloc] init];
    [self.view addSubview:_emoticonButton];
    [_emoticonButton addTarget:self action:@selector(emoticon) forControlEvents:UIControlEventTouchDown];
    [_emoticonButton setImage:[UIImage imageNamed:@"emoticon"] forState:UIControlStateNormal];
    
    _captureButton = [[PushButton alloc] init];
    [self.view addSubview:_captureButton];
    [_captureButton addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchDown];
    [_captureButton setImage:[UIImage imageNamed:@"capture"] forState:UIControlStateNormal];
    
    _photoLibraryButton = [[PushButton alloc] init];
    [self.view addSubview:_photoLibraryButton];
    [_photoLibraryButton addTarget:self action:@selector(photoLibrary) forControlEvents:UIControlEventTouchDown];
    [_photoLibraryButton setImage:[UIImage imageNamed:@"photolibrary"] forState:UIControlStateNormal];
    
    _sendButton = [[PushButton alloc] init];
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
    
    if(self.topicTid == 0 || self.topicTid == NSNotFound) {
        self.textTopic = [NSString stringWithFormat:@"%@ - 新建", self.category.name];
    }
    else {
        self.textTopic = [NSString stringWithFormat:@"No.%zi", self.topicTid];
    }
    
//    if(self.idReference > 0) {
//        _textView.text = [NSString stringWithFormat:@">>No.%zi\n", self.idReference];
//    }
    
    NSLog(@"finish.")
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.frame.size];
    if(!CGRectIsEmpty(self.frameSoftKeyboard)) {
        NSLog(@"got softkeyboard frame.[showing : %d]", self.isShowingSoftKeyboard);
        [layout setUseIncludedMode:@"Emoticon" includedTo:FRAMELAYOUT_NAME_MAIN withPostion:FrameLayoutPositionBottom andSizeValue:self.frameSoftKeyboard.size.height];
    }
    else {
        NSLog(@"not got softkeyboard frame.");
        [layout setUseIncludedMode:@"Emoticon" includedTo:FRAMELAYOUT_NAME_MAIN withPostion:FrameLayoutPositionBottom andSizePercentage:0.4];
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
    
//    [self layoutSubviewActions];
    //[self layoutSubviewAttachPicture];
    
    NS0Log(@"%@", layout);
    
    if(self.draftView) {
        CGFloat widthContain = self.view.frame.size.width;
        CGFloat heightContain = self.view.frame.size.height;
        CGRect frameCovered = CGRectMake(widthContain, 0, widthContain*0.7, heightContain);
        CGRect frameShow = CGRectOffset(frameCovered, widthContain*-0.7, 0);
        
        self.draftView.frame = frameShow;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(nil == _textView) {
        _textView = [[UITextView alloc] init];
        [self.view addSubview:_textView];
        LAYOUT_VIEW_BORDER(_textView, [UIColor blueColor], 1)
        
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.keyboardType = UIKeyboardTypeDefault;
        
//        if(self.idReference > 0) {
//            _textView.text = [NSString stringWithFormat:@">>No.%zi\n", self.idReference];
//        }
        
        if(self.originalContent) {
            _textView.text = self.originalContent;
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


- (void)inputString:(NSString*)string
{
    LOG_POSTION
    
    // 需在光标处插入键入内容, 不能直接append.
    // 获得光标所在的位置
    NSRange range = _textView.selectedRange;
    NSUInteger location = range.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = _textView.text;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location], string, [content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    _textView.text = result;
    
    range.location += string.length;
    range.length = 0;
    _textView.selectedRange = range;
}


- (void)showImage
{
    LOG_POSTION
    ImageViewController *vc = [[ImageViewController alloc] init];
    [vc setDisplayedImage:_imageView.image];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)inputEmoticon:(NSString*)emoticonString
{
    [self inputString:emoticonString];
    [[AppConfig sharedConfigDB] configDBAddClickOnString:emoticonString];
    
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


- (void)addInputToDraft
{
    if(_textView.text.length > 0) {
        BOOL ret = [[AppConfig sharedConfigDB] configDBDraftAdd:_textView.text];
        if(ret) {
            NSLog(@"已加入草稿");
            
            [self reloadDraftDataSource];
            [self.draftView reloadData];
        }
        else {
            NSLog(@"加入草稿失败");
        }
    }
    else {
        NSLog(@"无内容");
    }
}

#define TAG_draftView 0x1000000


- (void)reloadDraftDataSource
{
    self.drafts = [[AppConfig sharedConfigDB] configDBDraftGet];
}


- (void)showDraftView
{
    CGFloat widthContain = self.view.frame.size.width;
    CGFloat heightContain = self.view.frame.size.height;
    CGRect frameCovered = CGRectMake(widthContain, 0, widthContain*0.7, heightContain);
    CGRect frameShow = CGRectOffset(frameCovered, widthContain*-0.7, 0);

    self.draftView = [self.view viewWithTag:TAG_draftView];
    if(!self.draftView) {
        self.draftView = [[UITableView alloc] initWithFrame:frameCovered];
        [self.view addSubview:self.draftView];
        self.draftView.tag = TAG_draftView;
        self.draftView.dataSource = self;
        self.draftView.delegate = self;
        
        PushButton *footerButton = [[PushButton alloc] init];
        [footerButton addTarget:self action:@selector(addInputToDraft) forControlEvents:UIControlEventTouchDown];
        footerButton.frame = CGRectMake(0, 0, self.draftView.frame.size.width, 36);
        [footerButton setTitle:@"加入草稿(长按进入编辑模式)" forState:UIControlStateNormal];
        [footerButton setTitleColor:[UIColor colorWithName:@"CreateDraftText"] forState:UIControlStateNormal];
        footerButton.titleLabel.font = [UIFont fontWithName:@"CreateDraftText"];
        self.draftView.tableFooterView = footerButton;
        
        self.draftView.backgroundColor = [UIColor colorWithName:@"CreateDraftBackground"];
        
        //增加draft长按进入编辑功能.
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(draftLongPressToEditMode:)];
        [self.draftView addGestureRecognizer:longPressGr];
    }
    
    self.draftView.frame = frameCovered;
    
    [self reloadDraftDataSource];
    [self.draftView reloadData];

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.draftView.frame = frameShow;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}


- (void)draftLongPressToEditMode:(UILongPressGestureRecognizer *)gesture {
    NSLog(@"longPressToDo %@", gesture);
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        if(self.draftView.editing) {
            self.draftView.editing = NO;
        }
        else {
            self.draftView.editing = YES;
        }
    }
    NSLog(@"%@ editing %zd", self.draftView, self.draftView.editing);
}


- (void)hiddenDraftView
{
    CGFloat widthContain = self.view.frame.size.width;
    CGFloat heightContain = self.view.frame.size.height;
    CGRect frameCovered = CGRectMake(widthContain, 0, widthContain*0.7, heightContain);
//    CGRect frameShow = CGRectOffset(frameCovered, widthContain*-0.7, 0);
    
    if(self.draftView) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.draftView.frame = frameCovered;
                             self.draftView = nil;
                         }
                         completion:^(BOOL finished) {
                             [[self.view viewWithTag:TAG_draftView] removeFromSuperview];
                         }
         ];
    }
}


- (void)actionViaString:(NSString *)string
{
    if([string isEqualToString:@"草稿"]) {
        if(self.draftView) {
            [self hiddenDraftView];
            [self focusToInput];
        }
        else {
            [self notFocusToInput];
            [self showDraftView];
        }
    }
}


- (void)updatePostImage:(UIImage*)image
{
    [_imageView setContentMode:(UIViewContentModeScaleAspectFit)];
    //    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_imageView setImage:image];
    
    //    imageDataPost = UIImagePNGRepresentation(image);
    _imageDataPost = UIImageJPEGRepresentation(image, 0.8);
    NSLog(@"imageData length : %zi", [_imageDataPost length]);
    
    self.postImage = image;
    
    [self focusToInput];
}


- (void)removeImage {
    [_imageView setImage:nil];
    _imageDataPost = nil;
    
    [self.view setNeedsLayout];
}


//- (void)setCreateCategory:(NSString*)nameCategory withOriginalContent:(NSString*)originalContent
//{
//    LOG_POSTION
//    self.nameCategory = nameCategory;
//    self.topicTid = 0;
//    self.idReference = 0;
//    self.originalContent = originalContent;
//}
//
//
//- (void)setReplyId:(NSInteger)id
//{
//    LOG_POSTION
//    self.nameCategory = nil;
//    self.topicTid = id;
//    self.idReference = 0;
//}
//
//
//- (void)setReplyId:(NSInteger)id withReference:(NSInteger)idReference
//{
//    LOG_POSTION
//    self.nameCategory = nil;
//    self.topicTid = id;
//    self.idReference = idReference;
//}



- (void)setCreateCategory:(Category*)category replyTid:(NSInteger)tid withOriginalContent:(NSString*)originalContent
{
    self.category = category;
    self.topicTid = tid;
    self.originalContent = originalContent;
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
        [self hiddenDraftView];
    }
    
    [self.view setNeedsLayout];
}


- (void)sendToHostName:(NSString*)hostname
{
    self.dataSend = [[PostData alloc] init];
    self.dataSend.content = _textView.text;
    self.dataSend.postImage = self.postImage;
    
    PopupView *popupView = [[PopupView alloc] init];
    
    __weak typeof(popupView) popupViewBlock = popupView;
    __weak typeof(self)     selfBlock = self;
    
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
        [selfBlock focusToInput];
    };
    [popupView setTag:(NSInteger)@"PopupView"];
    [popupView popupInSuperView:self.view];
    
    [self.dataSend aysncPostToCategory:self.category
                               replyTo:self.topicTid
                       responseHandler:^(NSURLResponse* response) {
                        
                        }
     
                       progrossHandler:^(NSString *status, BOOL continuous) {
                           popupViewBlock.titleLabel = status;
                           popupViewBlock.numofTapToClose = 1;
                           
                           if(continuous) {
                               popupViewBlock.secondsOfstringIncrease = 1;
                           }
                       }
     
                     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                         if(!connectionError && data.length > 0) {
                             [selfBlock responseData:data onHostName:hostname];
                         }
                         
                         
                     }
     ];
}


- (void)responseData:(NSData*)data onHostName:(NSString*)hostname
{
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary*)obj;
        NSLog(@"dict : %@", [NSString stringFromNSDictionary:dict]);
        NSInteger code = [(NSNumber*)[dict objectForKey:@"code"] integerValue];
        BOOL success = [(NSNumber*)[dict objectForKey:@"success"] boolValue];
        NSLog(@"%zi, %d", code, success);
        
        if(200 == code || success){
            NSLog(@"post successfully.");
            popupView.titleLabel = @"发送成功";
            
            NSDictionary *dictPostData = [dict objectForKey:@"result"];
            PostData *postData = nil;
            if([dictPostData isKindOfClass:[NSDictionary class]]
               && nil != (postData = [PostData fromDictData:dictPostData atPage:0 onHostName:hostname])) {
 
                //主题贴.
                if(self.topicTid == 0 || self.topicTid == NSNotFound) {
                    Post *post = [[Post alloc] init];
                    post.tid        = postData.tid;
                    post.postedAt   = self.editedAt;
                    
                    [[AppConfig sharedConfigDB] configDBPostAdd:post];
                    
                    popupView.finish = ^(void) {
                        [self createTopicFinishedWithTid:postData.tid andPostData:postData];

                    };
                }
                else { // 回复帖.
                    Reply *reply = [[Reply alloc] init];
                    reply.tid           = postData.tid;
                    reply.repliedAt     = self.editedAt;
                    reply.tidBelongTo   = self.topicTid;
                    
                    NSLog(@"vbn %@", reply);
                    
                    [[AppConfig sharedConfigDB] configDBReplyAdd:reply];
                    
                    popupView.finish = ^(void) {
//                        [self.navigationController popViewControllerAnimated:YES];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateReplyFinish" object:self userInfo:nil];
                        [self createReplyFinishedWithTid:postData.tid andPostData:postData];
                    };
                }
            }
            else {
                popupView.finish = ^(void) {
                    [self.navigationController popViewControllerAnimated:YES];
                };
            }
        }
        else {
            NSString *msg = (NSString*)[dict objectForKey:@"msg"];
            if(!msg) {
                msg = (NSString*)[dict objectForKey:@"message"];
            }
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







- (void)clickSend {
    [self notFocusToInput];
    [self sendToHostName:HOSTNAME];
}


- (void)clickSend0
{
    
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
    self.editedAt = t * 1000.0;
    
    [self notFocusToInput];
    
    Host *host = [[AppConfig sharedConfigDB] configDBHostsGetCurrent];
    NSString *str = nil;
    
    if(self.topicTid == 0 || self.topicTid == NSNotFound) {
        str = [NSString stringWithFormat:@"%@/t/%zi/create", host.host, self.topicTid];
    }
    else {
        str =[NSString stringWithFormat:@"%@/%@/create", host.host, self.category.name];
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
    [dic setObject:@"" forKey:@"email"];
    [dic setObject:@"" forKey:@"title"];
    NSString *contentInput = [NSString stringWithFormat:@"客户端测试.[%@]沉的快...", self.category.name];
    contentInput = _textView.text;
    [dic setObject:contentInput forKey:@"content"];
    [dic setObject:@"" forKey:@"image"];
    
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    [ary addObject:@"name"];
    [ary addObject:@"email"];
    [ary addObject:@"title"];
    [ary addObject:@"content"];
    if(_imageDataPost) {
        [ary addObject:@"image"];
    }
    
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


- (void)responseData:(NSData*)data
{
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary*)obj;
        NSLog(@"dict : %@", [NSString stringFromNSDictionary:dict]);
        NSInteger code = [(NSNumber*)[dict objectForKey:@"code"] integerValue];
        BOOL success = [(NSNumber*)[dict objectForKey:@"success"] boolValue];
        NSInteger newCommitedTid = [(NSNumber*)[dict objectForKey:@"threadsId"] integerValue];
        NSLog(@"%zi, %d, %zi", code, success, newCommitedTid);
        
        if(200 == code && success){
            NSLog(@"post successfully.");
            popupView.titleLabel = @"发送成功";
            if(newCommitedTid > 0) {
                self.newCommitedTid = newCommitedTid;
                
                //主题贴.
                if(self.topicTid == 0 || self.topicTid == NSNotFound) {
                    Post *post = [[Post alloc] init];
                    post.tid        = newCommitedTid;
                    post.postedAt   = self.editedAt;
                    
                    [[AppConfig sharedConfigDB] configDBPostAdd:post];
                    
                    popupView.finish = ^(void) {
                        [self createTopicFinishedWithTid:newCommitedTid andPostData:nil];
                    };
                }
                else { // 回复帖.
                    Reply *reply = [[Reply alloc] init];
                    reply.tid           = newCommitedTid;
                    reply.repliedAt     = self.editedAt;
                    reply.tidBelongTo   = self.topicTid;
                    
                    NSLog(@"vbn %@", reply);
                    
                    [[AppConfig sharedConfigDB] configDBReplyAdd:reply];
                    
                    popupView.finish = ^(void) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateReplyFinish" object:self userInfo:nil];
                    };
                }
            }
            else {
                popupView.finish = ^(void) {
                    [self.navigationController popViewControllerAnimated:YES];
                };
            }
        }
        else {
            NSString *msg = (NSString*)[dict objectForKey:@"msg"];
            if(!msg) {
                msg = (NSString*)[dict objectForKey:@"message"];
            }
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




- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"%@数据包传输完成%s", [NSThread currentThread], __FUNCTION__);
    
    NSNumber *number = [[NSNumber alloc] initWithUnsignedInteger:(NSInteger)connection];
    NSMutableData *connectionData = (NSMutableData*)[_dictConnectionData objectForKey:number];
    NSLog(@"2. %@", [[NSString alloc] initWithData:connectionData encoding:NSUTF8StringEncoding]);
    
    NSData *data = [[NSData alloc] initWithData:connectionData];
    [_dictConnectionData removeObjectForKey:number];
    
    
    [self responseData:data];

#if 0
    
    
    
    PopupView *popupView = (PopupView*)[self.view viewWithTag:(NSInteger)@"PopupView"];
    popupView.numofTapToClose = 1;
    popupView.secondsOfstringIncrease = 0;
    
    NSObject *obj;
    NSDictionary *dict;
    obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if(obj && [obj isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary*)obj;
        NSLog(@"dict : %@", [NSString stringFromNSDictionary:dict]);
        NSInteger code = [(NSNumber*)[dict objectForKey:@"code"] integerValue];
        BOOL success = [(NSNumber*)[dict objectForKey:@"success"] boolValue];
        NSInteger newCommitedTid = [(NSNumber*)[dict objectForKey:@"threadsId"] integerValue];
        NSLog(@"%zi, %d, %zi", code, success, newCommitedTid);
        
        if(200 == code && success){
            NSLog(@"post successfully.");
            popupView.titleLabel = @"发送成功";
            if(newCommitedTid > 0) {
                self.newCommitedTid = newCommitedTid;
            
            
#if 0
                //占位record表.
                NSDictionary *infoInsert = @{
                                             @"tid":[NSNumber numberWithInteger:newCommitedTid],
                                             @"belongToTid":self.topicTid==0?[NSNumber numberWithInteger:newCommitedTid]:[NSNumber numberWithInteger:self.topicTid],
                                             @"createdAt":[NSNumber numberWithLongLong:0],
                                             @"updatedAt":[NSNumber numberWithLongLong:0],
                                             @"jsonstring":@""
                                             };
                
                [[AppConfig sharedConfigDB] configDBRecordInsertOrReplace:infoInsert];
#endif
                //主题贴.
                if(self.topicTid == 0 || self.topicTid == NSNotFound) {
                    Post *post = [[Post alloc] init];
                    post.tid        = newCommitedTid;
                    post.postedAt   = self.editedAt;
                    
                    [[AppConfig sharedConfigDB] configDBPostAdd:post];
                    
                    popupView.finish = ^(void) {
                        [self createFinishedWithTid:newCommitedTid];
                    };
                }
                else { // 回复帖.
                    Reply *reply = [[Reply alloc] init];
                    reply.tid           = newCommitedTid;
                    reply.repliedAt     = self.editedAt;
                    reply.tidBelongTo   = self.topicTid;
                    
                    NSLog(@"vbn %@", reply);
                    
                    [[AppConfig sharedConfigDB] configDBReplyAdd:reply];
                    
                    popupView.finish = ^(void) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateReplyFinish" object:self userInfo:nil];
                    };
                }
            }
            else {
                popupView.finish = ^(void) {
                    [self.navigationController popViewControllerAnimated:YES];
                };
            }
        }
        else {
            NSString *msg = (NSString*)[dict objectForKey:@"msg"];
            if(!msg) {
                msg = (NSString*)[dict objectForKey:@"message"];
            }
            popupView.titleLabel = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            popupView.titleLabel = msg;
        }
    }
    else {
        NSLog(@"obj [%@] nil or not NSDictionary class", @"JSONObjectWithData");
        popupView.titleLabel = @"发送失败.数据错误或服务器响应异常.";
    }
    
    [[CookieManage sharedCookieManage] showCookie:@"cookie after POST."];
#endif
}


- (void)createTopicFinishedWithTid:(NSInteger)tid andPostData:(PostData*)postData
{
    [self.navigationController popViewControllerAnimated:YES];
    DetailViewController *newDetailViewController = [[DetailViewController alloc] init];
    [newDetailViewController setDetailedTid:tid onCategory:self.category withData:postData];
    [self.navigationController pushViewController:newDetailViewController animated:YES];
}


- (void)createReplyFinishedWithTid:(NSInteger)tid andPostData:(PostData*)postData
{
    [self.navigationController popViewControllerAnimated:YES];
    DetailViewController *newDetailViewController = [[DetailViewController alloc] init];
    [newDetailViewController setDetailedTid:tid onCategory:self.category withData:postData];
    [self.navigationController pushViewController:newDetailViewController animated:YES];
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


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"------tableView------");
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSLog(@"------tableView------");
    return 1.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSLog(@"------tableView------");
    return 1.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView------");
    CGFloat height = 36;
    
    NSString *text = [self draftTextOnRow:indexPath.row];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont fontWithName:@"draftCellText"];
    
    CGSize maxSize = CGSizeMake(self.draftView.frame.size.width, MAXFLOAT);
    CGSize optimizeSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    height = optimizeSize.height + 36;

    NSLog(@"------tableView[%zd] heightForRowAtIndexPath return %.1f", indexPath.row, height);
    return height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"------tableView------");
    NSInteger rows = [self.drafts count];
    return rows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView[%zd] cellForRowAtIndexPath", indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        CGRect frame = cell.frame;
        frame.size.width = tableView.frame.size.width;
        [cell setFrame:frame];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"draftCellText"];
        cell.backgroundColor = tableView.backgroundColor;
    }
    else {
        
    }
    
    cell.textLabel.text = [self draftTextOnRow:indexPath.row];
    
    return cell;
}


- (NSString*)draftTextOnRow:(NSInteger)row
{
    Draft *draft = self.drafts[row];
    NSString *text = draft.content;
    
    return text;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NS0Log(@"点击的行数是:%zi", indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@ editing %zd", tableView, tableView.editing);
    NSLog(@"%@ editing %zd", self.draftView, self.draftView.editing);
    
    if(tableView.editing) {
        
    }
    else {
        [self inputString:[self draftTextOnRow:indexPath.row]];
     
        [self hiddenDraftView];
        [self focusToInput];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------tableView[%zd] willDisplayCell", indexPath.row);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_POSTION
    NSLog(@"%@ editing %zd", self.draftView, self.draftView.editing);
    
    Draft *draft = [self.drafts objectAtIndex:indexPath.row];

    //数据库删除.
    [[AppConfig sharedConfigDB] configDBDraftRemoveBySn:draft.sn];
    
    [self reloadDraftDataSource];
    [self.draftView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






















