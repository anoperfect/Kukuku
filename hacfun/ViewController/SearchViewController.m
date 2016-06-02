//
//  SearchViewController.m
//  hacfun
//
//  Created by Ben on 16/5/10.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "TidResultViewController.h"
#import "ModelAndViewInc.h"





@interface SearchViewController ()




@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) PushButton    *buttonSearch;
@property (nonatomic, strong) PushButton    *buttonGo;
//@property (nonatomic, strong) UILabel       *labelInfo;
//@property (nonatomic, strong) UITextView       *labelInfo1;
@property (nonatomic, strong) AlignTopLabel       *labelInfo;

@property (nonatomic, strong) NSMutableArray *tidResult;

@end

@implementation SearchViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textTopic = @"搜索";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.textView = [[UITextView alloc] init];
    [self.view addSubview:self.textView];
    self.textView.text = @"No.";
    self.textView.backgroundColor = [UIColor colorWithName:@"CustomInputViewBackground"];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithName:@"CustomInputViewBorder"].CGColor;
    self.textView.layer.cornerRadius = 2.7;
    self.textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textView.textColor = [UIColor colorWithName:@"CustomInputViewText"];
    
    self.buttonSearch = [[PushButton alloc] init];
    [self.view addSubview:self.buttonSearch];
    [self.buttonSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [self.buttonSearch addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchDown];
    self.buttonSearch.backgroundColor = [UIColor colorWithName:@"CustomButtonBackground"];
    self.buttonSearch.layer.borderWidth = 1;
    self.buttonSearch.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
    self.buttonSearch.layer.cornerRadius = 2.7;
    [self.buttonSearch setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
    
    
    self.buttonGo = [[PushButton alloc] init];
    [self.view addSubview:self.buttonGo];
    [self.buttonGo setTitle:@"前往搜索结果" forState:UIControlStateNormal];
    [self.buttonGo addTarget:self action:@selector(enterSearchResult:) forControlEvents:UIControlEventTouchDown];
    self.buttonGo.backgroundColor = [UIColor colorWithName:@"CustomButtonBackground"];
    self.buttonGo.layer.borderWidth = 1;
    self.buttonGo.layer.borderColor = [UIColor colorWithName:@"CustomButtonBorder"].CGColor;
    self.buttonGo.layer.cornerRadius = 2.7;
    [self.buttonGo setTitleColor:[UIColor colorWithName:@"CustomButtonText"] forState:UIControlStateNormal];
    
    
//    self.labelInfo = [[UILabel alloc] init];
//    self.labelInfo.text = @"搜索串号请以No.开头. 关键字搜索结果来自so.com";
//    self.labelInfo.backgroundColor = [UIColor whiteColor];
//    self.labelInfo.numberOfLines = 0;
//    self.labelInfo.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
////    [self.view addSubview:self.labelInfo];
//    
//    self.labelInfo1 = [[UITextView alloc] init];
//    self.labelInfo1.text = @"搜索串号请以No.开头. 关键字搜索结果来自so.com";
////    [self.view addSubview:self.labelInfo1];
//    self.labelInfo1.editable = NO;
//    self.labelInfo1.backgroundColor = [UIColor clearColor];
//    self.labelInfo1.layer.borderWidth = 1;
//    self.labelInfo1.layer.borderColor = [UIColor blueColor].CGColor;
//    self.labelInfo1.layer.cornerRadius = 2.7;
    
    
    self.labelInfo = [[AlignTopLabel alloc] init];
    self.labelInfo.text = @"搜索串号请以No.开头. 关键字搜索结果来自so.com";
    [self.view addSubview:self.labelInfo];
//    self.labelInfo0.editable = NO;
    self.labelInfo.backgroundColor = [UIColor colorWithName:@"CustomLabelBackground"];
    self.labelInfo.layer.borderWidth = 1;
    self.labelInfo.layer.borderColor = [UIColor colorWithName:@"CustomLabelBorder"].CGColor;
    self.labelInfo.layer.cornerRadius = 2.7;
    self.labelInfo.font = [UIFont fontWithName:@"CustomLabel"];
    self.labelInfo.numberOfLines = 0;
    self.labelInfo.textColor = [UIColor colorWithName:@"CustomLabelText"];
    
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    FrameLayout *layout = [[FrameLayout alloc] initWithSize:self.view.frame.size];
    [layout setUseIncludedMode:@"textViewAndSearchButton" includedTo:FRAMELAYOUT_NAME_MAIN withPostion:FrameLayoutPositionTop andSizeValue:50];
    [layout divideInVertical:@"textViewAndSearchButton" to:@"textViewAll" and:@"buttonSearchAll" withPercentage:0.6];
    [layout setUseEdge:@"textView" in:@"textViewAll" withEdgeValue:UIEdgeInsetsMake(16, 6, 0, 6)];
    [layout setUseEdge:@"buttonSearch" in:@"buttonSearchAll" withEdgeValue:UIEdgeInsetsMake(16, 6, 0, 6)];
    [layout setUseBesideMode:@"buttonGoPadding" besideTo:@"textViewAndSearchButton" withDirection:FrameLayoutDirectionBelow andSizeValue:10];
    [layout setUseBesideMode:@"buttonGoAll" besideTo:@"buttonGoPadding" withDirection:FrameLayoutDirectionBelow andSizeValue:44];
    [layout setUseEdge:@"buttonGo" in:@"buttonGoAll" withEdgeValue:UIEdgeInsetsMake(6, 6, 6, 6)];
    

    [layout setUseBesideMode:@"labelInfoPadding" besideTo:@"buttonGoAll" withDirection:FrameLayoutDirectionBelow andSizeValue:0];
    [layout setUseLeftMode:@"labelInfoALL" standardTo:@"labelInfoPadding" withDirection:FrameLayoutDirectionBelow];
    [layout setUseEdge:@"labelInfo" in:@"labelInfoALL" withEdgeValue:UIEdgeInsetsMake(6, 6, 6, 6)];

    NSLog(@"%@", layout);
    
    self.textView.frame         = [layout getCGRect:@"textView"];
    self.buttonSearch.frame     = [layout getCGRect:@"buttonSearch"];
    self.buttonGo.frame         = [layout getCGRect:@"buttonGo"];
    self.labelInfo.frame        = [layout getCGRect:@"labelInfo"];
    
    LOG_RECT(self.labelInfo.frame, @"labelInfo");
}


- (void)closeSoftKeyboard
{
    [self.textView resignFirstResponder];
}


- (void)appendInfo:(NSString*)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.labelInfo.text = [NSString stringWithFormat:@"%@%@", self.labelInfo.text, info];
    });
}


- (void)search:(id)sender
{
    NSString *keyString = @"No.";
    if([self.textView.text hasPrefix:keyString]) {
        NSInteger tid = [[self.textView.text substringFromIndex:keyString.length] integerValue];
        DetailViewController *vc = [[DetailViewController alloc] init];
        [vc setDetailedTid:tid onCategory:nil withData:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        self.tidResult = [[NSMutableArray alloc] init];
        self.labelInfo.text = @"搜索串号请以No.开头. 关键字搜索结果来自so.com";
        [self.textView resignFirstResponder];
        
        dispatch_queue_t concurrentQueue = dispatch_queue_create("search.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(concurrentQueue, ^(void){
            
            NSInteger pn = 1;
            while(1) {
                [self appendInfo:[NSString stringWithFormat:@"\n第%2zd页 : ", pn]];
                
                NSString *urlString = [NSString stringWithFormat:@"https://www.so.com/s?q=%@+site:kukuku.cc&pn=%zd", self.textView.text, pn];
//                NSString *urlString = [NSString stringWithFormat:@"https://www.so.com/s?q=chi", self.textView.text, pn];
                urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
                mutableRequest.HTTPMethod = @"GET";
                
                NSURLResponse *response = nil;
                NSError *error = nil;
                
                NSData *data = [NSURLConnection sendSynchronousRequest:mutableRequest returningResponse:&response error:&error];
                if(error || data.length == 0) {
                    NSLog(@"%@", error);
                    [self appendInfo:[NSString stringWithFormat:@"获取失败."]];
                    break;
                }
                
                NSString *parseContent = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NS0Log(@"page:%zd\n%@", pn, parseContent);
                
                NSArray* tidParsed = [self parseTidFromWWWContent:parseContent useEngine:@"so.com"];
                if(tidParsed.count == 0) {
                    [self appendInfo:[NSString stringWithFormat:@"结束解析."]];
                    break;
                }
                else {
                    
                    NSInteger add = 0;
                    NSInteger dup = 0;
                    for(NSNumber *tidNumber in tidParsed) {
                        if([self.tidResult indexOfObject:tidNumber] == NSNotFound) {
                            [self.tidResult addObject:tidNumber];
                            add ++;
                        }
                        else {
                            dup ++;
                        }
                    }
                    
                    if(dup == 0) {
                        [self appendInfo:[NSString stringWithFormat:@"解析到%zd条.", add]];
                    }
                    else {
                        [self appendInfo:[NSString stringWithFormat:@"解析到%zd条,重复%zd条.", add, dup]];
                    }
                }
                
                //开始解析数据.
                
                pn ++;
                
            }
            
            if(self.tidResult.count > 0) {
                
                
            }
        });
    }
}


- (NSArray*)parseTidFromWWWContent:(NSString*)parseContent useEngine:(NSString*)engineName
{
    NSMutableArray *tidParsed = [[NSMutableArray alloc] init];
    
    NSString *searchText = parseContent;
    NSRange rangeResult;
    NSRange rangeSearch = NSMakeRange(0, searchText.length);
    
    while(1) {
        NSString *regexString = @"No.[0-9]+ - 匿名版";
        
        rangeResult = [searchText rangeOfString:regexString options:NSRegularExpressionSearch range:rangeSearch];
        if (rangeResult.location == NSNotFound || rangeResult.length == 0) {
            break;
        }
        
        NSString *keyString = [searchText substringWithRange:rangeResult];
        NSLog(@"keyString = %@", keyString);
        NSInteger tid = [[keyString substringFromIndex:3] integerValue];
        NSNumber *tidNumber = [NSNumber numberWithInteger:tid];
        if(tid > 0 && [tidParsed indexOfObject:tidNumber] == NSNotFound) {
            [tidParsed addObject:tidNumber];
            NSLog(@"add : %zd", tid);
        }
        
        rangeSearch.location = rangeResult.location + rangeResult.length;
        rangeSearch.length = searchText.length - rangeSearch.location;
    }

    return [NSArray arrayWithArray:tidParsed];
}





- (void)enterSearchResult:(id)sender
{
    NSLog(@"%@", self.tidResult);

    TidResultViewController *vc = [[TidResultViewController alloc] init];
    NSArray<NSNumber*> *tidResult = self.tidResult;
    [vc assignTidResult:tidResult];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

