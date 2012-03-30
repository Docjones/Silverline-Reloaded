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
  //------------------------
  glActiveTexture(GL_TEXTURE1);
  glEnable(GL_TEXTURE_2D);

  glBindTexture(GL_TEXTURE_2D, [_textureManager textureByName:@"c003"]);
  
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);    //Add RGB with RGB
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
//  //------------------------
//  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_ADD);    //Add ALPHA with ALPHA
//  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PREVIOUS);
//  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
//  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
//  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
  t=[_textureManager getBlockWithNumber:12];

  glVertexPointer(2, GL_INT, 0, v);
  glTexCoordPointer(2, GL_INT, 0, t);
  glDrawArrays(GL_QUADS, 0, 4);
      
}

- (void)dealloc {
  [super dealloc];
}

@end
