//
//  ADNTokenStore.m
//  App.Net Integration
//
//  Created by Greg V on 4/17/13.
//
//

#import "ADNTokenStore.h"

#define TOKEN_FILE @"/var/mobile/Library/Preferences/.adn_token"

@implementation ADNTokenStore

+ (void)setToken:(NSString *)value {
    [value writeToFile:TOKEN_FILE atomically:YES encoding:NSStringEncodingConversionAllowLossy error:NULL];
};

+ (NSString *)getToken {
    return [[NSString alloc] initWithContentsOfFile:TOKEN_FILE usedEncoding:NULL error:NULL];
};

+ (void)deleteToken {
    [[NSFileManager defaultManager] removeItemAtPath:TOKEN_FILE error:NULL];
};

@end
