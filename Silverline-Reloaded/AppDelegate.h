//
//  AppDelegate.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  
  IBOutlet NSMutableArray *_players;
  IBOutlet id logView;
  IBOutlet NSTableView *tableView;
  
  AsyncSocket *listenSocket;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) NSMutableArray *_players;

@end
