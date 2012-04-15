//
//  UpdatingTextLabelViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdatingTextLabelViewController.h"

@implementation UpdatingTextLabelViewController
@synthesize textView, textLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/****************************************************************
 Updating Text in a label using a textfield and button
 ****************************************************************/
- (IBAction)submit:(id)sender {
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, %@", [textView text]];
    [textLabel setText:string];
    [textView resignFirstResponder];
}

/****************************************************************
 Dismissing the keyboard on click of background
 ****************************************************************/
- (IBAction)hideKeyboard:(id)sender {
    [textView resignFirstResponder];
}

/****************************************************************
 Dismissing the keyboard on clicking the Return button
 on keyboard
 ****************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, %@", [textField text]];
    [textLabel setText:string];
    [textView resignFirstResponder];
    return YES;
}

@end
