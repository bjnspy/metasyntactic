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

#import "HtmlUtilities.h"

#import "StringUtilities.h"

@implementation HtmlUtilities

+ (NSString*) convertHtmlEntities:(NSString*) string {
  if (string.length == 0) {
    return @"";
  }

  NSDictionary* dictionary =
  [NSDictionary dictionaryWithObjectsAndKeys:
   @" ",  @"&nbsp;",
   @"\"", @"&quot;",
   @"-",  @"&mdash;",
   @"-",  @"&ndash;",
   @"&",  @"&amp;",
   @"\"", @"&ldquo;",
   @"\"", @"&rdquo;",
   @"'",  @"&lsquo;",
   @"'",  @"&rsquo;",
   @"<",  @"&lt;",
   @">",  @"&gt;",
   nil];

  for (NSString* key in dictionary) {
    string = [string stringByReplacingOccurrencesOfString:key withString:[dictionary objectForKey:key]];
  }

  return string;
}


+ (NSString*) stripHtmlCodes:(NSString*) string {
  if (string.length == 0) {
    return @"";
  }

  NSArray* htmlCodes =
  [NSArray arrayWithObjects:
   @"a", @"em", @"p", @"b", @"i", @"br", @"br ",
   @"strong", @"tbody", @"tr", @"td", @"span",
   @"table", @"div", @"font", @"P", @"blockquote",
   @"ul", @"li", nil];

  for (NSString* code in htmlCodes) {
    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", code] withString:@""];
    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", code] withString:@""];
    string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@/>", code] withString:@""];
  }

  return string;
}


+ (NSString*) stripHtmlLinks:(NSString*) string {
  if (string.length == 0) {
    return @"";
  }

  NSArray* htmlCodes =
  [NSArray arrayWithObjects:
   @"a", @"p", @"table", @"span", @"div", @"font", @"A", nil];

  for (NSString* code in htmlCodes) {
    NSString* startTag = [NSString stringWithFormat:@"<%@ ", code];
    NSInteger index = 0;
    NSRange range;
    while ((range = [string rangeOfString:startTag
                                  options:0
                                    range:NSMakeRange(index, string.length - index)]).length > 0) {
      index = range.location + 1;
      NSRange closeAngleRange = [string rangeOfString:@">"
                                              options:0
                                                range:NSMakeRange(range.location, string.length - range.location)];
      if (closeAngleRange.length > 0) {
        string = [NSString stringWithFormat:@"%@%@", [string substringToIndex:range.location], [string substringFromIndex:closeAngleRange.location + 1]];
      }
    }
  }

  return string;
}


+ (NSString*) convertHtmlEncodings:(NSString*) string {
  if (string.length == 0) {
    return @"";
  }

  NSInteger index = 0;
  NSRange range;
  while ((range = [string rangeOfString:@"&#x"
                                options:0
                                  range:NSMakeRange(index, string.length - index)]).length > 0) {
    NSRange semiColonRange = [string rangeOfString:@";" options:0 range:NSMakeRange(range.location, string.length - range.location)];

    index = range.location + 1;
    if (semiColonRange.length > 0) {
      NSScanner* scanner = [NSScanner scannerWithString:string];
      [scanner setScanLocation:range.location + 3];
      unsigned hex;
      if ([scanner scanHexInt:&hex] && hex > 0) {
        string = [NSString stringWithFormat:@"%@%@%@",
                  [string substringToIndex:range.location],
                  [StringUtilities stringFromUnichar:(unichar) hex],
                  [string substringFromIndex:semiColonRange.location + 1]];
      }
    }
  }

  return string;
}


+ (NSString*) stripHtmlCommentsWorker:(NSString*) string
                                start:(NSString*) start {
  NSInteger index = 0;
  NSRange range;
  while ((range = [string rangeOfString:start
                                options:0
                                  range:NSMakeRange(index, string.length - index)]).length > 0) {
    NSRange endRange = [string rangeOfString:@"-->" options:0 range:NSMakeRange(range.location, string.length - range.location)];

    if (endRange.length > 0) {
      string = [NSString stringWithFormat:@"%@%@",
                [string substringToIndex:range.location],
                [string substringFromIndex:endRange.location + endRange.length]];
    }
  }
  return string;
}


+ (NSString*) stripHtmlComments:(NSString*) string {
  string = [self stripHtmlCommentsWorker:string start:@"<!--"];
  string = [self stripHtmlCommentsWorker:string start:@"</!--"];
  return string;
}


+ (NSString*) replaceParagraphs:(NSString*) string {
  return [string stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
}


+ (NSString*) collapseWhitespace:(NSString*) string
                          before:(NSString*) before
                           after:(NSString*) after {
  NSInteger oldLength;
  NSInteger newLength;
  do {
    oldLength = string.length;
    string = [string stringByReplacingOccurrencesOfString:before withString:after];
    newLength = string.length;
  } while (newLength < oldLength);

  return string;
}


+ (NSString*) collapseWhitespace:(NSString*) string {
  string = [self collapseWhitespace:string before:@"  " after:@" "];
  string = [self collapseWhitespace:string before:@"\n\n\n" after:@"\n\n"];
  return string;
}


+ (NSString*) removeHtml:(NSString*) string {
  if (string.length == 0) {
    return @"";
  }

  string = [self convertHtmlEntities:
            [self stripHtmlComments:
             [self stripHtmlCodes:
              [self stripHtmlLinks:
               [self convertHtmlEncodings:
                [self replaceParagraphs:string]]]]]];
  string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  string = [self collapseWhitespace:string];
  return [StringUtilities nonNilString:string];
}

@end
