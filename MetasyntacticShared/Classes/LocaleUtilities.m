// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "LocaleUtilities.h"

#import "NSArray+Utilities.h"

@implementation LocaleUtilities

static NSString* preferredLanguage = nil;
static NSLocale* currentLocale = nil;

+ (void) initialize {
  if (self == [LocaleUtilities class]) {
    currentLocale = [[NSLocale currentLocale] retain];

    NSArray* preferredLocalizations = [[NSBundle mainBundle] preferredLocalizations];
    if (preferredLocalizations.count > 0) {
      NSString* language = preferredLocalizations.firstObject;
      NSString* canonicalLanguage = [(NSString*)CFLocaleCreateCanonicalLanguageIdentifierFromString(NULL, (CFStringRef)language) autorelease];
      if ([[NSLocale ISOLanguageCodes] containsObject:canonicalLanguage]) {
        preferredLanguage = canonicalLanguage;
      }
    }

    if (preferredLanguage.length == 0) {
      preferredLanguage = [self isoLanguage];
    }

    if (preferredLanguage.length == 0) {
      preferredLanguage = @"en";
    }

    [preferredLanguage retain];
  }
}


+ (NSLocale*) currentLocale {
  return currentLocale;
}


+ (NSString*) preferredLanguage {
  return preferredLanguage;
}


+ (NSString*) isoCountry {
  return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}


+ (NSString*) isoLanguage {
  return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}


+ (NSString*) displayCountry {
  NSString* isoCountry = [self isoCountry];
  return [self displayCountry:isoCountry];
}


+ (NSString*) displayCountry:(NSString*) isoCountry {
  return [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:isoCountry];
}


+ (NSString*) displayLanguage:(NSString*) isoLanguage {
  return [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:isoLanguage];
}


+ (NSString*) displayLanguage {
  NSString* isoLanguage = [self preferredLanguage];
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
  NSString* isoLanguage = [self preferredLanguage];
  return [[self englishLocale] displayNameForKey:NSLocaleLanguageCode value:isoLanguage];
}


+ (BOOL) isEnglish {
  return [@"en" isEqual:[self preferredLanguage]];
}


+ (BOOL) isUnitedStates {
  return [@"US" isEqual:[self isoCountry]];
}


+ (BOOL) isJapanese {
  return [@"ja" isEqual:[self preferredLanguage]];
}

@end
