//
//  NSMutableArray+Characters.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Characters.h"
#import "Character.h"

@implementation NSMutableArray (Characters)

-(Character *)getCharacterWithName:(NSString *)name {
  for (Character *c in self) {
    if ([[c name] isEqualToString:name]) {
      return c;
    }
  }
  return nil;
}
-(Character *)getCharacterWithIndex:(NSUInteger)i {
  return [self objectAtIndex:i];
}
////////////////////////////////////////////
// Messagehandler
////////////////////////////////////////////
-(NSString *)handleMessage:(NSArray *)p withSocket:(AsyncSocket*)socket {  
  NSLog(@"Character Message: %@",p);
  
  if ([[p objectAtIndex:0] isEqualTo:@"C"]) {
    return [self createCharacterWithName:[p objectAtIndex:1]];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"D"]) {
    return [self deleteCharacterWithName:[p objectAtIndex:1]];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"L"]) {
    return [self listCharacters];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"S"]) {
    return [self signOnCharacter:[p objectAtIndex:1] forSocket:socket];
  }
  if ([[p objectAtIndex:0] isEqualTo:@"X"]) {
    return [self signOffCharacter:[p objectAtIndex:1]];
  }
  return nil;
}

// C|C
-(NSString *)createCharacterWithName:(NSString *)name {
  Character *c=[self getCharacterWithName:name];
  if (c) {
    return @"C|C|Error 0002: Charactername already exists";
  }
  c=[[Character alloc] initWithName:name];
  [self addObject:c];
  NSUInteger i=[self indexOfObject:c];
  [c setIndex:i];
  [c release];
  return [NSString stringWithFormat:@"C|C|Success|%d",i];
}

// C|D
-(NSString *)deleteCharacterWithName:(NSString *)name {
  Character *c=[self getCharacterWithName:name];
  if (c) {
    [self removeObject:c];
    [c release];
    return @"C|D|Success";
  } 
  return @"C|D|Error 0002: Character does not exists";
}

// C|D
-(NSString *)listCharacters {
  NSMutableString *ret=[[NSMutableString alloc] init];
  for (Character *c in self) {
    [ret appendString:[c list]];
  }
  [ret appendString:@"C|L|0\r\n"];
  return [NSString stringWithString:ret];
}

// C|S
-(NSString *)signOnCharacter:(NSString *)i forSocket:(AsyncSocket*)socket {
  int idx=[i intValue];
  Character *c=[self getCharacterWithIndex:idx];
  if (c) {
    if ([c playing]==YES) {
      return @"C|S|Error 0002: Character already signed in";
    } else {
      [c setConnection:socket andDelegate:self];
      return [c show];
    }
  } else {
      return @"C|S|Error 0001: Character does not exist";
  }
}

// C|X
-(NSString *)signOffCharacter:(NSString *)i {
  int idx=[i intValue];
  Character *c=[self getCharacterWithIndex:idx];
  if ([c playing]==NO) {
    return @"C|X|Error 0001: Character not signed on";
  } else {
    [c setPlaying:NO];
    [[c connection] disconnect];
    return @"C|X|Success|r|n";
  }
  
}
@end
