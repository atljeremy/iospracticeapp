//
//  PracticeAppViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PracticeAppViewController.h"
#import "GCDiscreetNotificationView.h"
#import <SBJson/SBJson.h>

@interface PracticeAppViewController () <SBJsonStreamParserAdapterDelegate>
@end

@implementation PracticeAppViewController
@synthesize textView, label, dataKeys, dataValues, theConnection, parser, adapter, posts, myTableView, notificationView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    /****************************************************************
     Fill Dictionary and Array with contents of plist file
    ****************************************************************/
//    NSString *listviewData = [[NSBundle mainBundle] 
//                              pathForResource:@"listviewPracticeData" 
//                              ofType:@"plist"];
//    
//    dataValues = [[NSDictionary alloc] initWithContentsOfFile:listviewData];
//    dataKeys = [dataValues allKeys];
    
    //Set a notification listener for the name "downloadCompleted". When this notification is received, fire the "updateTable" method.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"downloadCompleted" object:nil];
    
    //Setup Discreet Notifications
    notificationView = [[GCDiscreetNotificationView alloc] initWithText: @"This Is My Notification"
                                                           showActivity: NO
                                                     inPresentationMode: GCDiscreetNotificationViewPresentationModeTop 
                                                                 inView:self.view];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [self setLabel:nil];
    [self setDataKeys:nil];
    [self setDataValues:nil];
    [self setTheConnection:nil];
    [self setParser:nil];
    [self setAdapter:nil];
    [self setPosts:nil];
    [self setMyTableView:nil];
    [self setNotificationView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
 Dismissing the keyboard on click of
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
    [textField resignFirstResponder];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Set Main Text label
    NSDictionary *postObject = [posts objectAtIndex:indexPath.row];
    NSDictionary *post       = [postObject objectForKey:@"post"];
    NSString *postStatus     = [post objectForKey:@"status"];
    //NSString *string = @"TEST";
    [[cell textLabel] setText:postStatus];
    
    // Set Detail Text Label (Subtitle)
    //NSString *currentDataValue = [dataValues objectForKey:[dataKeys objectAtIndex:indexPath.row]];
    //[[cell detailTextLabel] setText:currentDataValue];
    
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




/****************************************************************
 SBJson example
****************************************************************/
- (IBAction)logJson:(id)sender {

    // We don't want *all* the individual messages from the
    // SBJsonStreamParser, just the top-level objects. The stream
    // parser adapter exists for this purpose.
    adapter = [[SBJsonStreamParserAdapter alloc] init];
    
    // Set ourselves as the delegate, so we receive the messages
    // from the adapter.
    adapter.delegate = self;
    
    // Create a new stream parser..
    parser = [[SBJsonStreamParser alloc] init];
    
    // .. and set our adapter as its delegate.
    parser.delegate = adapter;
    
    // Normally it's an error if JSON is followed by anything but
    // whitespace. Setting this means that the parser will be
    // expecting the stream to contain multiple whitespace-separated
    // JSON documents.
    parser.supportMultipleDocuments = YES;
    
    NSString *url = @"http://www.atlmetal.com/apps/live_stream.php?username=ATLmetal&format=json";
    
    NSURLRequest *theRequest=[NSURLRequest 
                              requestWithURL:[NSURL URLWithString:url]
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:60.0];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

}

#pragma mark SBJsonStreamParserAdapterDelegate methods

- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
    [NSException raise:@"unexpected" format:@"Should not get here"];
}

- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
	posts = [[NSArray alloc] initWithArray:(NSArray *) [dict objectForKey:@"posts"]];
    NSString *post = [posts objectAtIndex:(NSUInteger) 6];
    NSLog(@"The post is: %@", post);
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);

//*******************************************************************************
// I left this here to refer to for authentication
//
//	NSURLCredential *credential = [NSURLCredential 
//                                   credentialWithUser:username.text
//                                   password:password.text
//                                   persistence:NSURLCredentialPersistenceForSession];
//	
//	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//*******************************************************************************

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"Connection didReceiveData of length: %u", data.length);
	
	// Parse the new chunk of data. The parser will append it to
	// its internal buffer, then parse from where it left off in
	// the last chunk.
	SBJsonStreamParserStatus status = [parser parse:data];
	
	if (status == SBJsonStreamParserError) {
        NSLog(@"The parser encountered an error: %@", parser.error);
		
	} else if (status == SBJsonStreamParserWaitingForData) {
		NSLog(@"Parser waiting for more data");
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *stringError = (@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self showErrorDialogWithTitle:@"Error" andMessage:stringError];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *stringMessage = @"Connection Did Finish Loading!";
    [self showErrorDialogWithTitle:@"Finished!" andMessage:stringMessage];
    
    //Fire the "downloadCompleted" notification to the listener in the viewDidLoad method.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadCompleted" object:nil];
}




/****************************************************************
 Show/Hide Discreet Notification
****************************************************************/
- (IBAction) showHideNotification:(id)sender  {
    [self.notificationView showAndDismissAfter:2.0];
}



@end
