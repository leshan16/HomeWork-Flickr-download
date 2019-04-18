//
//  LCTPhotoViewController.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 15.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTPhotoViewControllerProtocol.h"

@interface LCTPhotoViewController : UIViewController <LCTPhotoViewControllerProtocol>

@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<LCTPhotoViewControllerProtocol> output; /**< Делегат внешних событий */

@end
