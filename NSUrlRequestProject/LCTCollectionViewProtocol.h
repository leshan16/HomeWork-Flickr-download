//
//  LCTCollectionViewProtocol.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

@protocol LCTCollectionViewProtocol <NSObject>
@optional

- (void)editingPhoto:(UIImage *)photo forIndex:(NSIndexPath *)indexPath;
- (void)downloadNewPage:(NSInteger)page;

@end
