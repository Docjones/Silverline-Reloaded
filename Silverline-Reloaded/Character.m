//
//  Character.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Character.h"
#define READ_TIMEOUT  15.0

@implementation Character

@synthesize name,xpos,ypos,container,index,playing,connection;



#pragma mark Drawing object OpenGL

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

#pragma mark AsyncSocketDelegate Protocol implementation

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)p {
	NSLog(@"Accepted client in Player %@:%hu", host, p);
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:READ_TIMEOUT tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
	if(msg)	{
    // Messagehandling:
    NSLog(@"Message in Character: %@",msg);
    
    NSArray *chunks = [msg componentsSeparatedByString:@"|"];
    NSString *action=[chunks objectAtIndex:0];
    
    NSString *ret;
    if ([action isEqualToString:@"C"]) {
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

#pragma mark Messagehandler

////////////////////////////////////////////
// Messagehandler
////////////////////////////////////////////
- (NSString *) handleMessage:(NSArray *)p {
  
  //	NSString *ret=Nil;
  
  if ([[p objectAtIndex:0] isEqualTo:@"M"]) {
    [self moveByX:[[p objectAtIndex:1] intValue] 
             andY:[[p objectAtIndex:2] intValue]];
  }
	
  return @"OK";
}


- (void) moveByX:(int)dx andY:(int)dy {
  // TODO: Mapcheck will go here
  [self willChangeValueForKey:@"xpos"];
  [self willChangeValueForKey:@"ypos"];
  
  xpos=(xpos+dx)%30;
  ypos=(ypos+dy)%23;
  
  [self didChangeValueForKey:@"xpos"];
  [self didChangeValueForKey:@"ypos"];
}

- (void)dealloc {
  [_textureManager release];
  [_textureName release];

  [connection disconnect];
  [connection release];
  [name release];
  [super dealloc];
}

#pragma mark NSCoding Protocol implementation

// NSCoding Protocol
- (id)initWithCoder:(NSCoder *)coder {
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
}

#pragma mark Silverline Protocol implementation

// Methods
// C|L
-(NSString *)list {
  return [NSString stringWithFormat:@"C|L|%d|%@\r\n",[self index],[self name]];
}

// C|S
-(NSString *)show {
  return [NSString stringWithFormat:@"C|S|%@|%d|%d\r\n",[self name],[self xpos],[self ypos]];
}

// C|C
- (id)initWithName:(NSString *)n {
  self = [super init];
  if (self) {
    [self setName:n];
    // Spawnpoint goes here.
    [self setXpos:5];
    [self setYpos:5];
  }
  return self;
}

#pragma mark Support

-(void)sendMessage:(NSString *)message {
  [connection writeData:[[message stringByAppendingString:@"\n\r"]
                          dataUsingEncoding:NSUTF8StringEncoding]
             withTimeout:-1 
                     tag:0];
  
}

-(void) setConnection:(AsyncSocket *)socket andDelegate:(id)delegate {
  connection=[socket retain];
  if ([connection canSafelySetDelegate]) {
    [connection setDelegate:self];
    [self setPlaying:YES];
  }
}
@end
