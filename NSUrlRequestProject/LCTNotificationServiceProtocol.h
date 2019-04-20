//
//  LCTNotificationServiceProtocol.h
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 20.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

@protocol LCTNotificationServiceProtocol <NSObject>
@optional

- (void)searchPhotoForNotification:(NSString *)searchString;

@end
