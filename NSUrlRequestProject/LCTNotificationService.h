//
//  LCTNotificationService.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 19.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTNotificationServiceProtocol.h"

@interface LCTNotificationService : NSObject <LCTNotificationServiceProtocol>

@property (nonatomic, weak) id output; /**< Делегат внешних событий */

-(void)startNoificationsWaiting;

@end
