//
//  MasterViewController.h
//  MasterDetailsTest
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *myList;
@property (strong, nonatomic) NSArray *myListKeys; 

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
