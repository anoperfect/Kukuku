//
//  ImagesDisplay.m
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import "FuncDefine.h"
#import "ImagesDisplay.h"
#import "NSLogn.h"





@interface ImagesDisplay () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *imageDatas;
@property (nonatomic, strong) UICollectionView *imagesView;

@property (nonatomic, assign) BOOL inMuiltSelectMode;
@property (nonatomic, strong) NSMutableArray *inMuiltSelectModeBOOLValues;


@property (nonatomic, copy)   void(^selectHandle)(NSInteger row);




@end


@implementation ImagesDisplay



- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        self.imagesView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, 250, 350) collectionViewLayout:flowLayout];
        self.imagesView.backgroundColor = [UIColor colorWithName:@"GalleryImageViewBackground"];
        [self.imagesView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        self.imagesView.delegate = self;
        self.imagesView.dataSource = self;
        [self addSubview:self.imagesView];
        
        self.inMuiltSelectMode = NO;
        
//        self.imagesView.backgroundColor = [UIColor whiteColor];
        
        
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    self.imagesView.frame = self.bounds;
}


- (void)setDisplayedImages:(NSArray*)imageDatas
{
    self.imageDatas = imageDatas;
    NSLog(@"image count : %zd", [imageDatas count]);
    
    [self inMuiltSelectModeBOOLValueReset];
    
    [self.imagesView reloadData];
}


- (void)inMuiltSelectModeBOOLValueReset
{
    self.inMuiltSelectModeBOOLValues = [[NSMutableArray alloc] init];
    NSInteger count = self.imageDatas.count;
    for (NSInteger index = 0; index < count; index ++) {
        [self.inMuiltSelectModeBOOLValues addObject:[NSNumber numberWithBool:NO]];
    }
}


//<UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageDatas count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    NSString *name = [NSString stringWithFormat:@"cell%zd", indexPath.row];
    LOG_RECT(cell.frame, name);
    
    UIImageView *imageView = [cell viewWithTag:10000000];
    if(!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.tag = 10000000;
        [cell addSubview:imageView];
    }
    
    imageView.frame = cell.bounds;
    imageView.image = [self.imageDatas objectAtIndex:indexPath.row];
//    imageView.image = [FuncDefine thumbOfImage:imageView.image
//                                     fitToSize:CGSizeMake(100, 127)
//                                   isFillBlank:YES
//                                     fillColor:[UIColor clearColor]
//                                   borderColor:[UIColor orangeColor] borderWidth:3.6];
    
    CGFloat heightSelectSign = 36;
    UIImageView *muiltSelectSign = [cell viewWithTag:10000001];
    if(!muiltSelectSign) {
        LOG_RECT(cell.frame, @"111");
        
        muiltSelectSign = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, heightSelectSign, heightSelectSign)];
        muiltSelectSign.tag = 10000001;
        [cell addSubview:muiltSelectSign];
        
        muiltSelectSign.layer.borderWidth = 2;
        muiltSelectSign.layer.borderColor = [UIColor blueColor].CGColor;
        muiltSelectSign.layer.cornerRadius = muiltSelectSign.frame.size.height / 2;
    }
    
    if(self.inMuiltSelectMode) {
        muiltSelectSign.hidden = NO;
        
        BOOL selected = [self.inMuiltSelectModeBOOLValues[indexPath.row] boolValue];
        if(selected) {
            muiltSelectSign.image = [UIImage imageNamed:@"selected"];
        }
        else {
            muiltSelectSign.image = nil;//[UIImage imageNamed:@"unselected"];
        }
        
        //存在复用问题, 因此重新设置居中.
        [FrameLayout setViewToCenter:muiltSelectSign];
    }
    else {
        muiltSelectSign.hidden = YES;
    }
    
    NSLog(@"...%@", [cell subviews]);
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - 20 ) / 3;
    CGFloat height = width;
    
    UIImage *image = [self.imageDatas objectAtIndex:indexPath.row];
    CGSize sizeImage = image.size;
    
    height = sizeImage.height / sizeImage.width * width;
    
    height = 127;
    
    return CGSizeMake(width, height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //导致错误.
    //[collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    LOG_POSTION
    
    NSLog(@"select %@, row %zd", indexPath, indexPath.row);
    
    if(self.inMuiltSelectMode) {
        BOOL selected = [self.inMuiltSelectModeBOOLValues[indexPath.row] boolValue];
        if(selected) {
            self.inMuiltSelectModeBOOLValues[indexPath.row] = @NO;
        }
        else {
            self.inMuiltSelectModeBOOLValues[indexPath.row] = @YES;
        }
        
        [self.imagesView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else {
        if(self.selectHandle) {
            self.selectHandle(indexPath.row);
        }
    }
}


//单选模式下点击后执行的动作.
- (void)setDidSelectHandle:(void(^)(NSInteger row))handle
{
    NSLog(@"******handle : %@", handle);
    self.selectHandle = handle;
    NSLog(@"******handle : %@", self.selectHandle);
}


//设置为多选模式. 非多选模式下, 点击任意的cell将触发selectImageHandle.
- (void)setMuiltSelectMode:(BOOL)isMuiltSelectMode
{
    self.inMuiltSelectMode = isMuiltSelectMode;
    
    [self inMuiltSelectModeBOOLValueReset];
    
    [self.imagesView reloadData];
}


//返回多选模式下, 选择的cell序列.
- (NSArray*)getResultMuiltSelectModeBOOLValues
{
    return [NSArray arrayWithArray:self.inMuiltSelectModeBOOLValues];
}


@end
