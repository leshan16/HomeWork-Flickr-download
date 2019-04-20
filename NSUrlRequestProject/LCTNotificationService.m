//
//  LCTNotificationService.m
//  NSUrlRequestProject
//
//  Created by Алексей Апестин on 19.04.19.
//  Copyright © 2019 Alexey Levanov. All rights reserved.
//

#import "LCTNotificationService.h"
@import UserNotifications;

typedef NS_ENUM(NSInteger, LCTTriggerType) {
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2,
};

@interface LCTNotificationService() <UNUserNotificationCenterDelegate>

@end

@implementation LCTNotificationService

- (instancetype)init
{
    self = [super init];
    if (self) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        // Получаем текущий notificationCenter
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        // Устанавливаем делегат
        center.delegate = self;
        
        // Указываем тип пушей для работы
        UNAuthorizationOptions options = UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge;
        
        // Запрашиваем доступ на работу с пушами
        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted)
                                  {
                                      NSLog(@"Доступ не дали");
                                  }
                              }];
    }
    return self;
}


-(void)startNoificationsWaiting
{
    [self sheduleLocalDateNotification];
    [self sheduleLocalIntervalNotification];
}


- (void)sheduleLocalIntervalNotification
{
    /* Контент - сущность класса UNMutableNotificationContent
     Содержит в себе:
     title: Заголовок, обычно с основной причиной показа пуша
     subtitle: Подзаговолок, не обязателен
     body: Тело пуша
     badge: Номер бейджа для указания на иконке приложения
     sound: Звук, с которым покажется push при доставке. Можно использовать default или установить свой из файла.
     launchImageName: имя изображения, которое стоит показать, если приложение запущено по тапу на notification.
     userInfo: Кастомный словарь с данными
     attachments: Массив UNNotificationAttachment. Используется для включения аудио, видео или графического контента.
     */
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Напоминание!";
    content.body = @"Вы давно не искали коров в Вашем любимом приложении";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @([self giveNewBadgeNumber] + 1);
    
    //  Добавляем кастомный attachement
    UNNotificationAttachment *attachment = [self imageAttachment:@"Cow" withExtension:@"jpg"];
    if (attachment)
    {
        content.attachments = @[attachment];
    }
    
    NSDictionary *dict = @{
                           @"searchString": @"Cow"
                           };
    content.userInfo = dict;
    
    // Смотрим разные варианты триггеров
    UNNotificationTrigger *whateverTrigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    // Создаем запрос на выполнение
    // Objective-C
    NSString *identifier = @"NotificationIdCow";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:whateverTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"Чот пошло не так... %@",error);
         }
     }];
}


- (void)sheduleLocalDateNotification
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Напоминание!";
    content.body = @"Вы давно не искали собачек в Вашем любимом приложении";
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @([self giveNewBadgeNumber] + 2);
    
    //  Добавляем кастомный attachement
    UNNotificationAttachment *attachment = [self imageAttachment:@"Dog" withExtension:@"jpeg"];
    if (attachment)
    {
        content.attachments = @[attachment];
    }
    
    NSDictionary *dict = @{
                           @"searchString": @"Dog"
                           };
    content.userInfo = dict;
    
    // Смотрим разные варианты триггеров
    UNNotificationTrigger *whateverTrigger = [self triggerWithType:LCTTriggerTypeDate];
    
    // Создаем запрос на выполнение
    // Objective-C
    NSString *identifier = @"NotificationIdDog";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:whateverTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"Чот пошло не так... %@",error);
         }
     }];
}


#pragma mark - Notifications

- (UNNotificationTrigger *)triggerWithType:(LCTTriggerType)triggerType
{
    switch (triggerType)
    {
        case LCTTriggerTypeInterval:
            return [self intervalTrigger];
        case LCTTriggerTypeLocation:
            return [self locationTrigger];
        case LCTTriggerTypeDate:
            return [self dateTrigger];
        default:
            break;
    }
    return nil;
}

- (UNTimeIntervalNotificationTrigger *)intervalTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
}

- (UNCalendarNotificationTrigger *)dateTrigger
{
    /* Если мы хотим сделать повторяющийся пуш каждый день в одно время, в dateComponents
     должны быть только часы/минуты/секунды */
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear +
                                     NSCalendarUnitMonth + NSCalendarUnitDay +
                                     NSCalendarUnitHour + NSCalendarUnitMinute +
                                     NSCalendarUnitSecond fromDate:date];
    
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
}

- (UNLocationNotificationTrigger *)locationTrigger
{
    /*
     // Создаем или получаем CLRegion и заводим триггер
     return [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
     */
    return nil;
}


#pragma mark - ContentType

- (NSInteger)giveNewBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (UNNotificationAttachment *)imageAttachment:(NSString *)imageName withExtension:(NSString *)extension;
{
    // Загружаем, нельзя использовать asserts
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:extension];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImage" URL:fileURL options:nil error:&error];
    
    return attachment;
}


#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if (completionHandler)
    {
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    UNNotificationContent *content = response.notification.request.content;
    if (content.userInfo[@"searchString"])
    {
        [self.output searchPhotoForNotification:content.userInfo[@"searchString"]];
        // Направляем куда-то в зависимости от параметров пуша
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}


@end
