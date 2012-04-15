//
//  IspeechViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IspeechViewController.h"

@implementation IspeechViewController
@synthesize ispeech;

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
    
    //Setup iSpeech
    ispeech = [ISpeechSDK ISpeech: @"327b1f95c61a4f64a561836677322fa6" 
                         provider: @"me.jeremyfox.testapp" 
                      application: @"iOS Test App" 
                    useProduction: YES];
}

- (void)viewDidUnload
{
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
 Example method for iSpeechw
 ****************************************************************/
- (IBAction)speak:(id)sender {
    [ispeech ISpeechSpeak:@"Hello! I'm iSpeech and I love to talk!"];
}
@end
