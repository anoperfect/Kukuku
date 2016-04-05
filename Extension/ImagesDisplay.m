//
//  ImagesDisplay.m
//  hacfun
//
//  Created by Ben on 16/4/5.
//  Copyright © 2016年 Ben. All rights reserved.
//

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


- (void)setDisplayedImages:(NSArray*)imageDatas
{
    self.imageDatas = imageDatas;
}


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
    if(indexPath.section==0) {
        cell.backgroundColor = [UIColor redColor];
    }
    else if(indexPath.section==1) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==1)
    {
        return CGSizeMake(50, 50);
    }
    else
    {
        return CGSizeMake(75, 30);
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section==0)
    {
        return UIEdgeInsetsMake(35, 25, 15, 25);
    }
    else
    {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}






















































@end
