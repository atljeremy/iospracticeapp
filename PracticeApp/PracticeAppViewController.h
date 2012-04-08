//
//  PracticeAppViewController.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;
@class GCDiscreetNotificationView;

@interface PracticeAppViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *dataValues;
@property (nonatomic, strong) NSArray *dataKeys;

@property (nonatomic, strong) NSArray *posts;

@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSURLConnection *theConnection;
@property (strong, nonatomic) SBJsonStreamParser *parser;
@property (strong, nonatomic) SBJsonStreamParserAdapter *adapter;
@property (nonatomic, retain) GCDiscreetNotificationView *notificationView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)submit:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)showAlert:(id)sender;
- (IBAction)logJson:(id)sender;
- (IBAction)showHideNotification:(id)sender;

- (void)showErrorDialogWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
