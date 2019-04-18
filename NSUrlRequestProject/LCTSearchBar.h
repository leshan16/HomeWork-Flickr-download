//
//  LCTSearchBar.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 14.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTSearchBarProtocol.h"

@interface LCTSearchBar : UISearchBar <UISearchBarDelegate, LCTSearchBarProtocol>

@property (nonatomic, weak) id<LCTSearchBarProtocol> output; /**< Делегат внешних событий */

@end
