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
#import "Character.h"

@interface Player : Character <AsyncSocketDelegate, NSCoding> {
  TextureManager *_textureManager;
  NSString *_textureName;
  
  AsyncSocket *_connection;
  
}

@property (assign) AsyncSocket *connection;

-(id)initFromCharacter:(Character*)c withSocket:(AsyncSocket *)socket;
- (id)initWithConnection:(AsyncSocket *)connection;
- (void) drawWithTimedDelta:(double)d;
- (NSString *) handleMessage:(NSArray *)p;
-(void)sendMessage:(NSString *)message;

@end
