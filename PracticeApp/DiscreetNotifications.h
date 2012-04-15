//
//  DiscreetNotifications.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDiscreetNotificationView.h"

@class GCDiscreetNotificationView;

@protocol DiscreetNotifications <NSObject>

@property (nonatomic, strong) GCDiscreetNotificationView *notificationView;
- (void) setNotificationLabel:(NSString *)text withActivityIndicator:(BOOL)activity andAnimation:(BOOL)animated;
- (void) showNotification;
- (void) hideNotification;

@optional
- (IBAction)showHideNotification:(id)sender;

@end
