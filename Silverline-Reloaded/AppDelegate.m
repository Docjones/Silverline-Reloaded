//
//  AppDelegate.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AsyncSocket.h"
#import "Player.h"

#define WELCOME_MSG  0
#define ECHO_MSG     1
#define WARNING_MSG  2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]



@implementation AppDelegate

@synthesize window = _window,_players;

- (id)init {
  self = [super init];
  if (self) {
    _players=[[NSMutableArray alloc] initWithCapacity:1];

		listenSocket = [[AsyncSocket alloc] initWithDelegate:self];
    
	  NSError *error = nil;
    [listenSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    if(![listenSocket acceptOnPort:9999 error:&error]) 		{
			[self logMessage:FORMAT(@"Error starting server: %@", error) withColor:[NSColor redColor]];
		}
		
		[self logMessage:FORMAT(@"Server started on port %hu", [listenSocket localPort]) withColor:[NSColor greenColor]];
  }
  return self;
}

- (void)dealloc {
  // Stop accepting connections
  [listenSocket disconnect];
  
  // By removing the Player objects, their dealloc message is performing a disconnect on the socket.
  // which will invoke the socketDidDisconnect: method,
  // which will remove the socket from the list.
  [_players removeAllObjects];
  [_players release];
  
  [self logMessage:@"Stopped Server" withColor:[NSColor greenColor]];
  [super dealloc];
}


- (void)awakeFromNib {
  NSLog(@"awakeFromNib");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSLog(@"applicationDidFinishLaunching");
	// Advanced options - enable the socket to contine operations even during modal dialogs, and menu browsing
	[listenSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

/////////////////////////////////////
// AsyncSocket interface:
/////////////////////////////////////

- (void)logMessage:(NSString *)msg withColor:(NSColor *)c {
  // Post Message
  NSLog(@"%@",msg);
  NSString *paragraph = [NSString stringWithFormat:@"%@\n", msg];
	
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
	[attributes setObject:c forKey:NSForegroundColorAttributeName];
	
	NSAttributedString *as = [[NSAttributedString alloc] initWithString:paragraph attributes:attributes];
	[[logView textStorage] appendAttributedString:as];
  [as release];
  // and scroll
	NSScrollView *scrollView = [logView enclosingScrollView];
	NSPoint newScrollOrigin;
	
	if ([[scrollView documentView] isFlipped])
		newScrollOrigin = NSMakePoint(0.0F, NSMaxY([[scrollView documentView] frame]));
	else
		newScrollOrigin = NSMakePoint(0.0F, 0.0F);
	
	[[scrollView documentView] scrollPoint:newScrollOrigin];
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
	[self logMessage:@"Incoming Client" withColor:[NSColor greenColor]];

  Player *p=[[Player alloc] initWithConnection:newSocket];
	[_players addObject:p];
  [p release];
  [tableView reloadData];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)p {
	[self logMessage:FORMAT(@"Accepted client %@:%hu", host, p) withColor:[NSColor greenColor]];
  
  NSString *welcomeMsg = @"Welcome to the Silverline-Server\r\n";
	NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:welcomeData withTimeout:-1 tag:WELCOME_MSG];
	
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	if(tag == ECHO_MSG)	{
		[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
	}
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
	if(msg)	{
		[self logMessage:msg withColor:[NSColor whiteColor]];
    // Messagehandling:
    if ([msg isEqualToString:@"QUIT"]) {
      // find the player and remove him (disconnect is done upon releasing the object)
      for (Player *p in _players) {
        if ([[p _connection] isEqual:sock]) {
          [_players removeObjectIdenticalTo:p];
          break;
        }
      }
      [tableView reloadData];
    }

    
	}	else	{
		[self logMessage:@"Error converting received data into UTF-8 String" withColor:[NSColor redColor]];
	}
	
	// Even if we were unable to write the incoming data to the log,
	// we're still going to echo it back to the client.
	[sock writeData:data withTimeout:-1 tag:ECHO_MSG];
}

/**
 * This method is called if a read has timed out.
 * It allows us to optionally extend the timeout.
 * We use this method to issue a warning to the user prior to disconnecting them.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
	if(elapsed <= READ_TIMEOUT)	{
		NSString *warningMsg = @"Are you still there?\r\n";
		NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
		
		[sock writeData:warningData withTimeout:-1 tag:WARNING_MSG];
		
		return READ_TIMEOUT_EXTENSION;
	}
	
	return 0.0;
}

- (void)onSocket:(AsyncSocket*) sock willDisconnectWithError:(NSError *)err {
	[self logMessage:FORMAT(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]) withColor:[NSColor greenColor]];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
  for (Player *p in _players) {
    if ([[p _connection] isEqual:sock]) {
      [_players removeObjectIdenticalTo:p];
      break;
    }
  }
  [tableView reloadData];
}


/////////////////////////////////////
// NSTableView Datasource interface:
/////////////////////////////////////

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return [_players count];
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  return [[_players objectAtIndex:rowIndex] name];
}
@end
