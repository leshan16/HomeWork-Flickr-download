//
//  LCTSearchBarProtocol.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

@protocol LCTSearchBarProtocol <NSObject>
@optional

- (void)flickrSearch: (NSString *)searchString;

@end
