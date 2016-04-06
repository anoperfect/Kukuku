//
//  ImagesDisplay.m
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//
#import "FuncDefine.h"
#import "ImagesDisplay.h"






@interface ImagesDisplay () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *imageDatas;
@property (nonatomic, strong) UICollectionView *imagesView;

@end


@implementation ImagesDisplay



- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        self.imagesView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, 250, 350) collectionViewLayout:flowLayout];
        self.imagesView.backgroundColor = [UIColor grayColor];
        [self.imagesView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
        self.imagesView.delegate = self;
        self.imagesView.dataSource = self;
         
        [self addSubview:self.imagesView];
    }
    return self;
}


- (void)layoutSubviews
{
    self.imagesView.frame = self.bounds;
//    self.imagesView.backgroundColor = [UIColor orangeColor];
}


- (void)setDisplayedImages:(NSArray*)imageDatas
{
    self.imageDatas = imageDatas;
    NSLog(@"image count : %zd", [imageDatas count]);
    [self.imagesView reloadData];
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
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.frame.size.width - 20 ) / 3;
    CGFloat height = width;
    
    UIImage *image = [self.imageDatas objectAtIndex:indexPath.row];
    CGSize sizeImage = image.size;
    
    height = sizeImage.height / sizeImage.width * width;
    
    return CGSizeMake(width, height);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //导致错误.
    //[collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    LOG_POSTION
    
    NSLog(@"select %@, row %zd", indexPath, indexPath.row);
    
    
}






















































@end
