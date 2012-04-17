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
#import "NSMutableArray+Accounts.h"
#import "NSMutableArray+Players.h"
#import "Player.h"
#import "Account.h"


@interface AppDelegate : NSObject <NSApplicationDelegate> {
  
  NSMutableArray *_accounts;
  NSMutableArray *_players;

  IBOutlet id logView;
  IBOutlet NSTableView *tableView;
 
  AsyncSocket *listenSocket;
	
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSMutableArray *_players;

@end
