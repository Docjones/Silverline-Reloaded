//
//  Player.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize _connection,name,xpos,ypos;

- (id)initWithConnection:(AsyncSocket *)connection {
  self = [super init];
  if (self) {
    _connection=[connection retain];
    xpos=rand()%30;
    ypos=rand()%23;
    _textureManager=[TextureManager sharedManager];
    name=[[NSString stringWithFormat:@"Player%d",rand()%32768] retain];
  }
  return self;
}

- (NSString *)description {
  return name;
}

- (void) drawWithTimedDelta:(double)d {
  GLint *t;
  GLint v[] = { 
    16*xpos   ,16*ypos,
    16*xpos+16,16*ypos,
    16*xpos+16,16*ypos+16,
    16*xpos   ,16*ypos+16
  };
  glActiveTexture(GL_TEXTURE1);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, [_textureManager textureByName:@"c003"]);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
  
 
  t=[_textureManager getBlockWithNumber:12];

  glVertexPointer(2, GL_INT, 0, v);
  glTexCoordPointer(2, GL_INT, 0, t);
  glDrawArrays(GL_QUADS, 0, 4);
      
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
