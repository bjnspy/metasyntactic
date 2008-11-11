// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "LocaleUtilities.h"


@implementation LocaleUtilities

+ (NSString*) isoCountry {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}


+ (NSString*) isoLanguage {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}


+ (NSString*) displayCountry {
    NSString* isoCountry = [self isoCountry];
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:isoCountry];
}


+ (NSString*) displayLanguage:(NSString*) isoLanguage {
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:isoLanguage];
}


+ (NSString*) displayLanguage {
    NSString* isoLanguage = [self isoLanguage];
    return [self displayLanguage:isoLanguage];
}


+ (NSLocale*) englishLocale {
    return [[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease];
}


+ (NSString*) englishCountry {
    NSString* isoCountry = [self isoCountry];
    return [[self englishLocale] displayNameForKey:NSLocaleCountryCode value:isoCountry];
}


+ (NSString*) englishLanguage {
    NSString* isoLanguage = [self isoLanguage];
    return [[self englishLocale] displayNameForKey:NSLocaleLanguageCode value:isoLanguage];
}


+ (BOOL) isEnglish {
    return [@"en" isEqual:[self isoLanguage]];
}


+ (BOOL) isJapanese {
    return [@"ja" isEqual:[self isoLanguage]];
}

@end