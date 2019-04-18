//
//  LCTSearchBar.m
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 14.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTSearchBar.h"

@implementation LCTSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barStyle = UIBarStyleDefault;
        self.delegate = self;
        self.placeholder = @"Search string";
        
    }
    return self;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *newText = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    [self.output flickrSearch:newText];
}
@end
