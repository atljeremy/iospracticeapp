//
//  SbjsonViewController.m
//  PracticeApp
//
//  Created by Jeremy Fox on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JsonViewController.h"
//#import <SBJson/SBJson.h>
#import "GCDiscreetNotificationView.h"
#import "RKTStatus.h"

@implementation JsonViewController
@synthesize posts, notificationView, myTableView;

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    notificationView = [[GCDiscreetNotificationView alloc] initWithText: @"This Is My Notification"
                                                           showActivity: YES
                                                     inPresentationMode: GCDiscreetNotificationViewPresentationModeTop 
                                                                 inView: self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(updateTable) 
                                                 name: @"downloadCompleted" object:nil];
    
    UIBarButtonItem *getJson = [[UIBarButtonItem alloc] initWithTitle: @"Show" 
                                                                style: UIBarButtonItemStylePlain 
                                                               target: self 
                                                               action: @selector(getJson:)];
    self.navigationItem.rightBarButtonItem = getJson;
}

- (void)viewDidUnload
{
    [self setPosts:nil];
    [self setNotificationView:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)loadView {
    [super loadView];
	
	// Setup View and Table View	
	self.title = @"RestKit Tweets";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadButtonWasPressed:)];
    
	UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BG.png"]];
	imageView.frame = CGRectOffset(imageView.frame, 0, -64);
	
	[self.view insertSubview:imageView atIndex:0];
	
	//_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStylePlain];
	//_tableView.dataSource = self;
	//_tableView.delegate = self;		
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view addSubview:_tableView];
	
	// Load statuses from core data
	[self loadObjectsFromDataStore];
}

- (void)loadObjectsFromDataStore {
	NSFetchRequest* request = [RKTStatus fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	posts = [RKTStatus objectsWithFetchRequest:request];
}

- (void)loadData {
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:@"/status/user_timeline/RestKit" delegate:self];
}

- (IBAction)getJson:(id)sender {
    // Load the object model via RestKit
	[self loadData];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdatedAt"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"Loaded statuses: %@", objects);
	[self loadObjectsFromDataStore];
	[myTableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

#pragma mark UITableViewDelegate methods
/****************************************************************
 TableView Delegate Methods
****************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [[[posts objectAtIndex:indexPath.row] text] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 9000)];
	return size.height + 10;
}

#pragma mark - TableView Data Source methods
/****************************************************************
 TableView Data Source Required Methods
 ****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [posts count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDate* lastUpdatedAt = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdatedAt"];
	NSString* dateString = [NSDateFormatter localizedStringFromDate:lastUpdatedAt 
                                                          dateStyle:NSDateFormatterShortStyle 
                                                          timeStyle:NSDateFormatterMediumStyle];
	if (nil == dateString) {
		dateString = @"Never";
	}
	return [NSString stringWithFormat:@"Last Load: %@", dateString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
                                      reuseIdentifier: cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"listbg.png"]];
    }
    
    // Set Main Text label
//    NSDictionary *postObject = [posts objectAtIndex:indexPath.row];
//    NSDictionary *post       = [postObject objectForKey:@"post"];
//    NSString *postStatus     = [post objectForKey:@"status"];
    
    RKTStatus* status = [posts objectAtIndex:indexPath.row];
    cell.textLabel.text = status.text;
    
    // Set an image in cell on left
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"star" ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    [[cell imageView] setImage:image];
    
    // Set an indicator (more details/info) in cell on right
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/****************************************************************
 Custom TableView Methods
 ****************************************************************/
- (void)updateTable {
    [myTableView reloadData];
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




#pragma mark - SBJson Custom getJson method
/****************************************************************
 SBJson Framework Example
 ****************************************************************/
//- (IBAction)getJson:(id)sender {
//    
//    [self setNotificationLabel:@"Fetching Json" withActivityIndicator:YES andAnimation:YES];
//    [self showNotification];
//    
////    adapter = [[SBJsonStreamParserAdapter alloc] init];
////    adapter.delegate = self;
////    
////    parser = [[SBJsonStreamParser alloc] init];
////    parser.delegate = adapter;
////    parser.supportMultipleDocuments = YES;
//    
//    NSString *url = @"http://www.atlmetal.com/apps/live_stream.php?username=ATLmetal&format=json";
//    
//    NSURLRequest *theRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:url] 
//                                                cachePolicy: NSURLRequestUseProtocolCachePolicy 
//                                            timeoutInterval: 60.0];
//    
//    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    
//}

#pragma mark - SBJsonStreamParserAdapterDelegate methods
/****************************************************************
 SBJson Methods
****************************************************************/
//- (void)parser:(SBJsonStreamParser *)parser foundArray:(NSArray *)array {
//    [NSException raise:@"unexpected" format:@"Should not get here"];
//}
//
//- (void)parser:(SBJsonStreamParser *)parser foundObject:(NSDictionary *)dict {
//	posts = [[NSArray alloc] initWithArray:(NSArray *) [dict objectForKey:@"posts"]];
//}

#pragma mark - NSURLConnectionDelegate methods
/****************************************************************
 NSURLConnection Methods
****************************************************************/
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//	NSLog(@"Connection didReceiveData of length: %u", data.length);
//	
////	SBJsonStreamParserStatus status = [parser parse:data];
////	
////	if (status == SBJsonStreamParserError) {
////        NSLog(@"The parser encountered an error: %@", parser.error);
////		
////	} else if (status == SBJsonStreamParserWaitingForData) {
////		NSLog(@"Parser waiting for more data");
////	}
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    NSString *stringError = [NSString stringWithFormat:@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
//    [self setNotificationLabel:stringError withActivityIndicator:YES andAnimation:YES];
//    [self showNotification];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    //Fire the "downloadCompleted" notification to the listener in the viewDidLoad method.
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadCompleted" object:nil];
//    
//    [self hideNotification];
//}

@end
