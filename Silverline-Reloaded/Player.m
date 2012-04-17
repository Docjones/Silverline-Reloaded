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

- (id)initWithCoder:(NSCoder *)coder
{
  if (self) {
    xpos=[coder decodeIntForKey:@"PlayerXpos"];
    ypos=[coder decodeIntForKey:@"PlayerYpos"];
    name=[coder decodeObjectForKey:@"PlayerName"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeInt:xpos forKey:@"PlayerXpos"];
  [encoder encodeInt:ypos forKey:@"PlayerYpos"];
  [encoder encodeObject:name forKey:@"PlayerName"];
  _textureManager=[TextureManager sharedManager];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"%@ (%d/%d),%@",name,xpos,ypos,_textureName];
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
- (NSString *) handleMessage:(NSArray *)p {
  
  NSLog(@"Message: %@",p);
	NSString *ret=Nil;
  
  if ([[p objectAtIndex:0] isEqualTo:@"M"]) {
    [self moveByX:[[p objectAtIndex:1] intValue] 
             andY:[[p objectAtIndex:2] intValue]];
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
