//
//  UpdatingTextLabelViewController.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatingTextLabelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)submit:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
