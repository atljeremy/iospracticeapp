//
//  PracticeAppViewController.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpeechSDK.h"

//@class SBJsonStreamParser;
//@class SBJsonStreamParserAdapter;
@class GCDiscreetNotificationView;

@interface PracticeAppViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *dataValues;
@property (nonatomic, strong) NSArray *dataKeys;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSURLConnection *theConnection;
//@property (nonatomic, strong) SBJsonStreamParser *parser;
//@property (nonatomic, strong) SBJsonStreamParserAdapter *adapter;
@property (nonatomic, retain) GCDiscreetNotificationView *notificationView;
@property (nonatomic, retain) ISpeechSDK *ispeech;

@property (nonatomic, weak) IBOutlet UITextField *textView;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UITableView *myTableView;

- (IBAction)submit:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)showAlert:(id)sender;
- (IBAction)getJson:(id)sender;
- (IBAction)showHideNotification:(id)sender;
- (IBAction)speak:(id)sender;

- (void) showErrorDialogWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void) setNotificationLabel:(NSString *)text withActivityIndicator:(BOOL)activity andAnimation:(BOOL)animated;
- (void) showNotification;
- (void) hideNotification;

@end
