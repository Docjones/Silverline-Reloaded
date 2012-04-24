//
//  Character.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "TextureManager.h"

@interface Character : NSObject <AsyncSocketDelegate,NSCoding> {

  // Drawing objects
  TextureManager *_textureManager;
  NSString *_textureName;
  
  // Communication
  AsyncSocket *connection;

  // Administrative
  NSMutableArray *container;
  NSUInteger index;

  // Game related
  BOOL playing;
  NSString *name;
  int xpos;
  int ypos;
}

@property (retain) NSString *name;
@property (assign) int xpos;
@property (assign) int ypos;
@property (assign) NSUInteger index;
@property (assign) NSMutableArray *container;
@property (assign) AsyncSocket *connection;
@property (assign) BOOL playing;

-(void) drawWithTimedDelta:(double)d;
-(NSString *) handleMessage:(NSArray *)p;
-(void)sendMessage:(NSString *)message;
-(void) setConnection:(AsyncSocket *)socket andDelegate:(id)delegate;

// C|C
- (id)initWithName:(NSString *)n;

// C|L
-(NSString *)list;
// C|S
-(NSString *)show;

@end
