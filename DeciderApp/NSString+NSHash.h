//
//  NSString+NSHash.h
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 12/2/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSHash_AdditionalHashingAlgorithms)

/**
 Creates a MD5 string of the NSData object as string representation.
 */
- (NSString*) MD5;

/**
 Creates a SHA1 string of the NSData object as string representation.
 */
- (NSString*) SHA1;

/**
 Creates a SHA256 string of the NSData object as string representation.
 */
- (NSString*) SHA256;

@end
