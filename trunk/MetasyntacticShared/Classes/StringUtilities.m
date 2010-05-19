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

#import "StringUtilities.h"

#import "LocaleUtilities.h"

@implementation StringUtilities

static NSString* articles[] = {
  @"Der", @"Das", @"Ein", @"Eine", @"The",
  @"A", @"An", @"La", @"Las", @"Le",
  @"Les", @"Los", @"El", @"Un", @"Une",
  @"Una", @"Il", @"O", @"Het", @"De",
  @"Os", @"Az", @"Den", @"Al", @"En",
  @"L'"
};


static NSString* suffixes[] = {
  @", Der", @", Das", @", Ein", @", Eine", @", The",
  @", A", @", An", @", La", @", Las", @", Le",
  @", Les", @", Los", @", El", @", Un", @", Une",
  @", Una", @", Il", @", O", @", Het", @", De",
  @", Os", @", Az", @", Den", @", Al", @", En",
  @", L'"
};


static NSString* prefixes[] = {
  @"Der ", @"Das ", @"Ein ", @"Eine ", @"The ",
  @"A ", @"An ", @"La ", @"Las ", @"Le ",
  @"Les ", @"Los ", @"El ", @"Un ", @"Une ",
  @"Una ", @"Il ", @"O ", @"Het ", @"De ",
  @"Os ", @"Az ", @"Den ", @"Al ", @"En ",
  @"L'"
};


+ (NSString*) makeCanonical:(NSString*) title {
  if (title.length == 0) {
    return @"";
  }

  title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  for (NSInteger i = 0; i < ArrayLength(articles); i++) {
    NSString* suffix = suffixes[i];
    if ([title hasSuffix:suffix]) {
      return [NSString stringWithFormat:@"%@%@", prefixes[i], [title substringToIndex:(title.length - suffix.length)]];
    }
  }

  return title;
}


+ (NSString*) makeDisplay:(NSString*) title {
  if (title.length == 0) {
    return @"";
  }

  title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  for (NSInteger i = 0; i < ArrayLength(articles); i++) {
    NSString* prefix = prefixes[i];
    if ([title hasPrefix:prefix]) {
      return [NSString stringWithFormat:@"%@%@", [title substringFromIndex:prefix.length], suffixes[i]];
    }
  }

  return title;
}


+ (NSString*) nonNilString:(NSString*) string {
  if (string == nil) {
    return @"";
  }

  return string;
}


+ (NSString*)                      string:(NSString*) string
      byAddingPercentEscapesUsingEncoding:(NSStringEncoding) encoding {
  NSString* result =
  (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                     (CFStringRef)string,
                                                     NULL,                        // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                     CFSTR(":/=,!$&'()*+;[]@#?"), // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                     CFStringConvertNSStringEncodingToEncoding(encoding)); // encoding
  return [result autorelease];
}


+ (NSString*) stringByAddingPercentEscapes:(NSString*) string {
  return [self string:string byAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+ (NSString*) asciiString:(NSString*) string {
  NSString* asciiString = [[[NSString alloc] initWithData:[string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
                                                 encoding:NSASCIIStringEncoding] autorelease];
  return asciiString;
}


+ (NSString*) stringFromUnichar:(unichar) c {
  return [NSString stringWithCharacters:&c length:1];
}


+ (NSArray*) splitIntoChunks:(NSString*) string {
  NSMutableArray* array = [NSMutableArray array];

  NSInteger start = 0;
  NSInteger textLength = string.length;
  NSCharacterSet* newlineCharacterSet = [NSCharacterSet newlineCharacterSet];
  NSCharacterSet* whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
  NSCharacterSet* whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

  while (start < textLength) {
    NSInteger end = MIN(start + 1000, textLength);

    NSRange newlineRange = [string rangeOfCharacterFromSet:newlineCharacterSet
                                                   options:0
                                                     range:NSMakeRange(end, textLength - end)];

    if (newlineRange.length > 0) {
      if (newlineRange.location < 2000 + start) {
        end = newlineRange.location;
      } else {
        NSRange whitespaceRange = [string rangeOfCharacterFromSet:whitespaceCharacterSet
                                                          options:0
                                                            range:NSMakeRange(end, textLength - end)];

        if (whitespaceRange.location < 2000 + start) {
          end = whitespaceRange.location;
        }
      }
    }

    NSString* substring = [string substringWithRange:NSMakeRange(start, end - start)];
    substring = [substring stringByTrimmingCharactersInSet:whitespaceAndNewlineCharacterSet];

    [array addObject:substring];
    start = end;
  }

  return array;
}


+ (NSUInteger) hashString:(NSString*) string {
  if (string.length == 0) {
    return 0;
  }

  unichar result = [string characterAtIndex:0];
  for (NSInteger i = 1; i < string.length; i++) {
    result = 31 * result + [string characterAtIndex:i];
  }

  return result;
}


+ (unichar) starCharacter {
  return (unichar)0x2605;
}


+ (NSString*) emptyStarString {
  return [StringUtilities stringFromUnichar:(unichar)0x2606];
}


+ (NSString*) halfStarString {
  return [StringUtilities stringFromUnichar:(unichar)0x272F];
}


+ (NSString*) starString {
  return [StringUtilities stringFromUnichar:[self starCharacter]];
}


+ (NSString*) randomString:(NSInteger) length {
  NSMutableString* string = [NSMutableString string];
  for (NSInteger i = 0; i < length; i++) {
    [string appendFormat:@"%c", ((rand() % 26) + 'a')];
  }
  return string;
}


NSComparisonResult compareStringsNaturally(NSString* string1, NSString* string2) {
  static NSStringCompareOptions comparisonOptions =
    NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;

  NSRange string1Range = NSMakeRange(0, string1.length);

  return [string1 compare:string2
                  options:comparisonOptions
                    range:string1Range
                   locale:[LocaleUtilities currentLocale]];
}


NSComparisonResult compareStringsFunction(id i1, id i2, void* context) {
  return compareStringsNaturally(i1, i2);
}

@end
