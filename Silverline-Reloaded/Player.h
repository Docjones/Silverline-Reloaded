//
//  Player.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextureManager.h"
#import "AsyncSocket.h"

@interface Player : NSObject {
  TextureManager *_textureManager;
  AsyncSocket *_connection;
  
  NSString *name;
  int xpos;
  int ypos;
  
}

@property (assign) AsyncSocket *_connection;
@property (assign) NSString *name;
@property (assign) int xpos;
@property (assign) int ypos;

- (id)initWithConnection:(AsyncSocket *)connection;
- (void) drawWithTimedDelta:(double)d;
@end
