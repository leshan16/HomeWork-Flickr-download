//
//  LCTCollectionView.m
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTCollectionView.h"
#import "LCTCollectionViewCell.h"


@interface LCTCollectionView ()

@end

@implementation LCTCollectionView

+ (LCTCollectionView *)createCollectionView:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame) / 2 - 1, CGRectGetWidth(frame) / 2);
    
    LCTCollectionView *collectionView = [[LCTCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    [collectionView registerClass:[LCTCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LCTCollectionViewCell class])];
    collectionView.arrayImage = [NSMutableArray new];

    return collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayImage.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCTCollectionViewCell *cell;
        
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCTCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor cyanColor];
    if (indexPath.row < self.arrayImage.count)
    {
        cell.coverImageView.image = self.arrayImage[indexPath.row];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LCTCollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCTCollectionViewCell class]) forIndexPath:indexPath];
    
    [self.output editingPhoto:self.arrayImage[indexPath.row] forIndex:indexPath];
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    if (indexPath.row >= 25 * self.page - 2)
    {
        self.page++;
        [self.output downloadNewPage:self.page];
    }
}


@end
