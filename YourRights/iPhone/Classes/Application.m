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

#import "Application.h"

#import "Model.h"

@implementation Application

// Application storage directories
static NSString* rssDirectory = nil;

+ (void) initializeDirectories {
  [self addDirectory:rssDirectory = [[self cacheDirectory] stringByAppendingPathComponent:@"RSS"]];
  [self createDirectories];
}


+ (void) initialize {
  if (self == [Application class]) {
    [self initializeDirectories];
  }
}


+ (NSArray*) directoriesToKeep {
  return [NSArray array];
}


+ (NSString*) rssDirectory {
  return rssDirectory;
}

@end
