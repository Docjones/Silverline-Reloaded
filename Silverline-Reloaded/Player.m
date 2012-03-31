//
//  Player.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init {
  self = [super init];
  if (self) {
    _textureManager=[TextureManager sharedManager];
  }
  return self;
}

- (void) drawWithTimedDelta:(double)d atX:(int)x andY:(int)y {
  GLint *t;
  GLint v[] = { 
    16*x   ,16*y,
    16*x+16,16*y,
    16*x+16,16*y+16,
    16*x   ,16*y+16
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

- (void)dealloc {
  [super dealloc];
}

@end
