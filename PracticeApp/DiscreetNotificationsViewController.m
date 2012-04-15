//
//  DiscreetNotificationsViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiscreetNotificationsViewController.h"
#import "GCDiscreetNotificationView.h"

@implementation DiscreetNotificationsViewController
@synthesize notificationView;

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
    
    //Setup Discreet Notifications
    notificationView = [[GCDiscreetNotificationView alloc] initWithText: @"This Is My Notification"
                                                           showActivity: YES
                                                     inPresentationMode: GCDiscreetNotificationViewPresentationModeTop 
                                                                 inView: self.view];
}

- (void)viewDidUnload
{
    [self setNotificationView:nil];
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
 Show/Hide Discreet Notification
 ****************************************************************/
- (IBAction) showHideNotification:(id)sender {
    [self setNotificationLabel:@"YO! This is a Discreet Notification" withActivityIndicator:YES andAnimation:YES];
    [self.notificationView showAndDismissAfter:2.0];
}

- (void) showNotification  {
    [self.notificationView showAnimated];
}

- (void) hideNotification  {
    [self.notificationView hideAnimatedAfter:0.5];
}

- (void) setNotificationLabel:(NSString *)text withActivityIndicator:(BOOL)activity andAnimation:(BOOL)animated {
    [self.notificationView setTextLabel:text andSetShowActivity:activity animated:animated];
}

@end
