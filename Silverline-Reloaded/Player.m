//
//  Player.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "AsyncSocket.h"

@implementation Player

@synthesize _connection,name,xpos,ypos;

- (id)initWithConnection:(AsyncSocket *)connection {
  self = [super init];
  if (self) {
    name=[[NSString stringWithFormat:@"Player%d",rand()%32768] retain];
    xpos=rand()%30;
    ypos=rand()%23;
    _textureName=[[NSString stringWithFormat:@"c%03d",rand()%3+1] retain];

    _textureManager=[TextureManager sharedManager];

    _connection=[connection retain];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@(%d/%d),%@",name,xpos,ypos,_textureName];
}

- (void) drawWithTimedDelta:(double)d {
  GLint *t;
  GLint v[] = { 
    16*xpos   ,16*ypos,
    16*xpos+16,16*ypos,
    16*xpos+16,16*ypos+16,
    16*xpos   ,16*ypos+16
  };
  glBindTexture(GL_TEXTURE_2D, [_textureManager textureByName:_textureName]);

  t=[_textureManager getBlockWithNumber:12];

  glVertexPointer(2, GL_INT, 0, v);
  glTexCoordPointer(2, GL_INT, 0, t);
  glDrawArrays(GL_QUADS, 0, 4);
      
}

////////////////////////////////////////////
// Messagehandler
////////////////////////////////////////////
- (NSString *) handleMessage:(NSString *)message {
  
  NSLog(@"Message: %@",message);
	NSString *ret=Nil;
	NSArray *chunks = [message componentsSeparatedByString:@"|"];
  
  NSString *action=[chunks objectAtIndex:0];
  NSString *function=[chunks objectAtIndex:1];
  NSArray *p=[NSArray arrayWithArray:[chunks subarrayWithRange:NSMakeRange(2, [chunks count]-2)]];
  
  if ([action isEqualTo:@"P"]) {
    if ([function isEqualTo:@"M"]) {
      [self moveByX:[[p objectAtIndex:2] intValue] 
               andY:[[p objectAtIndex:3] intValue]];
    }
  }
	
  return ret;
}


- (void) moveByX:(int)dx andY:(int)dy {
  // TODO: Mapcheck will go here
  xpos=(xpos+dx)%30;
  ypos=(ypos+dy)%23;
}

- (void)dealloc {
  [_connection disconnect];
  [_connection release];
  [super dealloc];
}

@end
