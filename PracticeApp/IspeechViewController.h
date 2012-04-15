//
//  IspeechViewController.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISpeechSDK.h"

@interface IspeechViewController : UIViewController

@property (nonatomic, retain) ISpeechSDK *ispeech;

- (IBAction)speak:(id)sender;

@end
