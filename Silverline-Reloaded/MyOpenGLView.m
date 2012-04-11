//
//  MyOpenGLView.m
//  Silverline Server
//
//  Created by Marc on 23.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyOpenGLView.h"

@implementation MyOpenGLView

#define TARGET_FPS 0.5f

////////////////////////////////////////////
// OpenGL
////////////////////////////////////////////
- (id)init {
  self = [super init];
  if (self) {
    _world=[[World alloc] init];

  }
  return self;
}

- (void)awakeFromNib {
  _world=[[World alloc] init];
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

}

- (void) prepareOpenGL {
  [[self window] makeFirstResponder:self];
  
  // GLuint units;
  // glGetIntegerv(GL_MAX_TEXTURE_UNITS, &units);
  // NSLog(@"Texture Units: %d",units);
  // => 8 Units
  
  // Turn off unnecessary operations
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_LIGHTING);
  glDisable(GL_CULL_FACE);
  glDisable(GL_STENCIL_TEST);
  glDisable(GL_DITHER);
  glEnable(GL_BLEND);
  glEnable(GL_TEXTURE_2D);
  
  // activate pointer to vertex & texture array
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  
  aTimer=[[NSTimer timerWithTimeInterval:1.0f/TARGET_FPS target:self selector:@selector(animationTrigger:) userInfo:self repeats:YES] retain];	
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSEventTrackingRunLoopMode];
  
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
  
  glClear(GL_COLOR_BUFFER_BIT);

  [_world draw:rect withTimedDelta:delta];
  
  for (Player *p in _players) {
    [p drawWithTimedDelta:delta];
  };

 
  glFlush();
  startTime=lastTime;
  //  [FPS setDoubleValue:1.0f/delta];
}
@end
