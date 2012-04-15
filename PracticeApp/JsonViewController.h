//
//  SbjsonViewController.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscreetNotifications.h"
#import <RestKit/RestKit.h>

@interface JsonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DiscreetNotifications, RKObjectLoaderDelegate>

@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, weak) IBOutlet UITableView *myTableView;

- (IBAction)getJson:(id)sender;

- (void)loadObjectsFromDataStore;

@end
