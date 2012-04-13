//
//  AppDelegate.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "MyOpenGLView.h"
#import "Player.h"

@interface NSMutableArray (Players)
-(Player *)getPlayerWithSocket:(AsyncSocket *)socket;
@end


@interface AppDelegate : NSObject <NSApplicationDelegate> {
  
  NSMutableArray *_players;

  IBOutlet id logView;
  IBOutlet NSTableView *tableView;
 
  AsyncSocket *listenSocket;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSMutableArray *_players;

@end
