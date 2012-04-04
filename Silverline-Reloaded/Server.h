//
//  Server.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 01.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

@interface Server : NSObject<AsyncSocketDelegate>
{
	AsyncSocket *listenSocket;
	NSMutableArray *connectedSockets;
	
	BOOL isRunning;
	
    IBOutlet id logView;
    IBOutlet id portField;
    IBOutlet id startStopButton;
}

- (IBAction)startStop:(id)sender;
@end
