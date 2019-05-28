//
//  ShadowCoelManager.m
//
//  Created by LEI on 4/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import "ShadowCoel.h"

@implementation ShadowCoel

+ (NSString *) sharedGroupIdentifier {
    // reverted back
    // very curious why grabbing value from Info.plist will result in cannot connect to VPN all the time
    // it needs to be fixed like this as always
    return @"group.com.coelwu.shadowcoel";
}

+ (NSURL *)sharedUrl {
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:[self sharedGroupIdentifier]];
}

+ (NSURL *)sharedDatabaseUrl {
    return [[self sharedUrl] URLByAppendingPathComponent:@"ShadowCoel.realm"];
}

+ (NSUserDefaults *)sharedUserDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:[self sharedGroupIdentifier]];
}

+ (NSURL * _Nonnull)sharedGeneralConfUrl {
    return [[ShadowCoel sharedUrl] URLByAppendingPathComponent:@"general.xxx"];
}

+ (NSURL *)sharedSocksConfUrl {
    return [[ShadowCoel sharedUrl] URLByAppendingPathComponent:@"socks.xxx"];
}

+ (NSURL *)sharedProxyConfUrl {
    return [[ShadowCoel sharedUrl] URLByAppendingPathComponent:@"proxy.xxx"];
}

+ (NSURL *)sharedHttpProxyConfUrl {
    return [[ShadowCoel sharedUrl] URLByAppendingPathComponent:@"http.xxx"];
}

+ (NSURL * _Nonnull)sharedLogUrl {
    return [[ShadowCoel sharedUrl] URLByAppendingPathComponent:@"tunnel.log"];
}

@end
