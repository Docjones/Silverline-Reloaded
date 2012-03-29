//
//  MyOpenGLView.m
//  Silverline Server
//
//  Created by Marc on 23.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyOpenGLView.h"

@implementation MyOpenGLView

#define TARGET_FPS 60.0f

////////////////////////////////////////////
// OpenGL
////////////////////////////////////////////
- (id)init {
  self = [super init];
  if (self) {
    _textureManager=[TextureManager sharedManager];
  }
  return self;
}

- (void)awakeFromNib {
  _textureManager=[TextureManager sharedManager];
}

- (void)dealloc {
  [_world release];
  [super dealloc];
}

- (void) reshape {
  
  NSRect rect=[self bounds];
  
  glViewport(0, 0, (GLsizei) rect.size.width , (GLsizei) rect.size.height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  
  glOrtho(0, rect.size.width, rect.size.height, 0,-1,1); // heigth + zero exchanged (turn upside down) 
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

//  glViewport(0, 0, [_map getWidth]*16, [_map getHeigth]*16);
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity();
//  
//  glOrtho(0, [_map getWidth]*16, [_map getHeigth]*16, 0,-1,1); // heigth + zero exchanged (turn upside down) 
//  glMatrixMode(GL_MODELVIEW);
//  glLoadIdentity();
  
}

- (void) prepareOpenGL {
  [[self window] makeFirstResponder:self];
  
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_BLEND);
  glEnable(GL_TEXTURE_2D);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
  
  // activate pointer to vertex & texture array
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  
  aTimer=[[NSTimer timerWithTimeInterval:1.0f/TARGET_FPS target:self selector:@selector(animationTrigger:) userInfo:self repeats:YES] retain];	
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSEventTrackingRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
  
  startTime=0.0f;
  lastTime=0.0f;
  framedelta=0.0f;
  delta=0.0f;
}	

-(void)animationTrigger:(NSTimer*)timer {
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
  lastTime=(double)CFAbsoluteTimeGetCurrent();
  delta=(lastTime-startTime);
  [self draw:delta];
  startTime=lastTime;
  //  [FPS setDoubleValue:1.0f/delta];
}

-(void)draw:(double)d {
  glClear(GL_COLOR_BUFFER_BIT);
  // Drawing code goes here
  
  glFlush();
}


@end
