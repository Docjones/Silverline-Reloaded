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

@synthesize _connection,name,xpos,ypos,container;

- (id)initWithConnection:(AsyncSocket *)connection {
  self = [super init];
  if (self) {
    name=[[NSString stringWithFormat:@"Player%d",rand()%32768] retain];
    xpos=rand()%30;
    ypos=rand()%23;
    _textureName=[[NSString stringWithFormat:@"c%03d",rand()%3+1] retain];

    _textureManager=[TextureManager sharedManager];

    _connection=[connection retain];
    if ([_connection canSafelySetDelegate]) {
      [_connection setDelegate:self];
    }
        
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

-(void)sendMessage:(NSString *)message {
  [_connection writeData:[[message stringByAppendingString:@"\n\r"]
                          dataUsingEncoding:NSUTF8StringEncoding]
             withTimeout:-1 
                     tag:0];

}


- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
  

}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
	if(msg)	{
    // Messagehandling:
    
    NSArray *chunks = [msg componentsSeparatedByString:@"|"];
    NSString *action=[chunks objectAtIndex:0];
    
    NSString *ret;
    if ([action isEqualToString:@"P"]) {
      NSArray *p=[chunks subarrayWithRange:NSMakeRange(1, [chunks count]-1)];
      ret=[self handleMessage:p];
    }
    
    [sock writeData:[[ret stringByAppendingString:@"\n\r"] dataUsingEncoding:NSUTF8StringEncoding]
        withTimeout:-1 tag:0];
    
	}	
}

/**
 * This method is called if a read has timed out.
 * It allows us to optionally extend the timeout.
 * We use this method to issue a warning to the user prior to disconnecting them.
 **/
- (NSTimeInterval)onSocket:(AsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
	if(elapsed <= 15.0)	{
		NSString *warningMsg = @"Are you still there?\r\n";
		NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
		
		[sock writeData:warningData withTimeout:-1 tag:0];
		
		return 10;
	}
	
	return 0.0;
}

- (void)onSocket:(AsyncSocket*) sock willDisconnectWithError:(NSError *)err {

}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
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
	
  return @"OK";
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
