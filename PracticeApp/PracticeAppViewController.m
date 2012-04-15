//
//  PracticeAppViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PracticeAppViewController.h"
#import "GCDiscreetNotificationView.h"

@implementation PracticeAppViewController
@synthesize textView, label, dataKeys, dataValues, theConnection, posts, myTableView, notificationView, ispeech;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set a notification listener for the name "downloadCompleted". When this notification is received, fire the "updateTable" method.
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(updateTable) 
                                                 name: @"downloadCompleted" object:nil];
    
    //Setup Discreet Notifications
    notificationView = [[GCDiscreetNotificationView alloc] initWithText: @"This Is My Notification"
                                                           showActivity: YES
                                                     inPresentationMode: GCDiscreetNotificationViewPresentationModeTop 
                                                                 inView: self.view];
    
    //Setup iSpeech
    ispeech = [ISpeechSDK ISpeech: @"327b1f95c61a4f64a561836677322fa6" 
                         provider: @"me.jeremyfox.testapp" 
                      application: @"iOS Test App" 
                    useProduction: YES];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setLabel:nil];
    [self setDataKeys:nil];
    [self setDataValues:nil];
    [self setTheConnection:nil];
    [self setPosts:nil];
    [self setMyTableView:nil];
    [self setNotificationView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




#pragma mark - My Practice Methods

/****************************************************************
 Updating Text in a label using a textfield and button
****************************************************************/
- (IBAction)submit:(id)sender {
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, %@", [textView text]];
    [label setText:string];
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
    [label setText:string];
    [textView resignFirstResponder];
    return YES;
}




/****************************************************************
 Showing an alert dialog with 2 buttons on button click
****************************************************************/
- (IBAction)showAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Alert" 
                          message:@"An error has occurred!" 
                          delegate:nil 
                          cancelButtonTitle:@"Cancel" 
                          otherButtonTitles:@"Ok", nil];
    [alert show];
}

/****************************************************************
 Showing an alert dialog with 1 button dynamically
****************************************************************/
- (void)showErrorDialogWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *showAlert = [[UIAlertView alloc] 
                          initWithTitle:title 
                          message:message 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
    [showAlert show];
}



/****************************************************************
 TableView Data Source Required Methods
****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                      reuseIdentifier: cellIdentifier];
    }
    
    // Set Main Text label
    NSDictionary *postObject = [posts objectAtIndex:indexPath.row];
    NSDictionary *post       = [postObject objectForKey:@"post"];
    NSString *postStatus     = [post objectForKey:@"status"];
    [[cell textLabel] setText:postStatus];
    
    // Set an image in cell on left
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [[cell imageView] setImage:image];
    
    // Set an indicator (more details/info) in cell on right
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/****************************************************************
 TableView Delagte Methods
****************************************************************/
// Need to find some to use for example purposes!

/****************************************************************
 Custom TableView Methods
****************************************************************/
- (void)updateTable {
    [myTableView reloadData];
}




#pragma mark SBJson Custom getJson method

/****************************************************************
 SBJson Framework Example
****************************************************************/
- (IBAction)getJson:(id)sender {
    
    [self setNotificationLabel:@"Fetching Json" withActivityIndicator:YES andAnimation:YES];
    [self showNotification];
    
//    adapter = [[SBJsonStreamParserAdapter alloc] init];
//    adapter.delegate = self;
//    
//    parser = [[SBJsonStreamParser alloc] init];
//    parser.delegate = adapter;
//    parser.supportMultipleDocuments = YES;
    
    NSString *url = @"http://www.atlmetal.com/apps/live_stream.php?username=ATLmetal&format=json";
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:url] 
                                                cachePolicy: NSURLRequestUseProtocolCachePolicy 
                                            timeoutInterval: 60.0];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

}

#pragma mark SBJsonStreamParserAdapterDelegate methods
//- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
//    [NSException raise:@"unexpected" format:@"Should not get here"];
//}
//
//- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
//	posts = [[NSArray alloc] initWithArray:(NSArray *) [dict objectForKey:@"posts"]];
//}

#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Connection didReceiveData of length: %u", data.length);
	
//	SBJsonStreamParserStatus status = [parser parse:data];
//	
//	if (status == SBJsonStreamParserError) {
//        NSLog(@"The parser encountered an error: %@", parser.error);
//		
//	} else if (status == SBJsonStreamParserWaitingForData) {
//		NSLog(@"Parser waiting for more data");
//	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *stringError = [NSString stringWithFormat:@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    [self showErrorDialogWithTitle:@"Error" andMessage:stringError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Fire the "downloadCompleted" notification to the listener in the viewDidLoad method.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadCompleted" object:nil];
    
    [self hideNotification];
}




/****************************************************************
 Show/Hide Discreet Notification
****************************************************************/
- (IBAction) showHideNotification:(id)sender  {
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




/****************************************************************
 Example method for iSpeech
****************************************************************/
- (IBAction)speak:(id)sender {
    [ispeech ISpeechSpeak:@"Hello! I'm iSpeech and I love to talk!"];
}


@end
