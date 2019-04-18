//
//  LCTPhotoViewControllerProtocol.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 18.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

@protocol LCTPhotoViewControllerProtocol <NSObject>
@optional

- (void)addEditingPhoto:(UIImage *)photo forIndex:(NSIndexPath *)indexPath;

@end
