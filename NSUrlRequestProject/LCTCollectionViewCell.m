//
//  LCTCollectionViewCell.m
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTCollectionViewCell.h"


@interface LCTCollectionViewCell()

@end

@implementation LCTCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _coverImageView.backgroundColor = [UIColor yellowColor];
        _coverImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_coverImageView];
    }
    return self;
}


@end
