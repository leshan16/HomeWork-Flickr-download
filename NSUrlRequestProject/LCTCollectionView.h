//
//  LCTCollectionView.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTCollectionViewProtocol.h"

@interface LCTCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource, LCTCollectionViewProtocol>

@property (nonatomic, weak) id<LCTCollectionViewProtocol> output; /**< Делегат внешних событий */
@property (nonatomic, strong) NSMutableArray *arrayImage;
@property (nonatomic, assign) NSInteger page;

+ (LCTCollectionView *)createCollectionView:(CGRect)frame;

@end
