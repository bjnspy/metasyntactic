# Introduction #

Protocol Buffers are a way of encoding structured data in an efficient yet extensible format.  For more information see the main page [here](http://code.google.com/p/protobuf/).

This project contains a port of Protocol Buffers that can be used in OSX 10.5 and later and on the iPhone OS 2.0 and later.

The port includes a Protocol Buffer compiler (protoc) and a Protocol Buffer static library that you link into any project that you want protobuf support for.  The protoc compiler supports almost all the features of the protobuf 2 language and when given .proto files as input will generate the specialized Objective-C classes necessary to both read and write instances of the messages contained therein.  These classes, along with the supplied static library, will then allow your code to read and write protobuf instances simply and in a typesafe manner.

# Quick Example #

You write a .proto file like this:

```
message Person {
  required int32 id = 1;
  required string name = 2;
  optional string email = 3;
}
```

Then you compile it with protoc, the protocol buffer compiler, to produce code in Objective-C.

You use that code like this to produce raw protobuf data from a message:

```
Person* person = [[[[[Person builder] setId:123]
                                    setName:@"Bob"]
                                   setEmail:@"bob@example.com"] build];
NSData* data = [person data];
```

Or like this to read a message back from raw protobuf data:
```
NSData* raw_data = ...;
Person* person = [Person parseFromData:raw_data];
```

# Gory Details #

## Creating the Protocol Buffer Compiler (`protoc`) ##

In order to compiler and use `protoc` you must first have installed XCode and the rest of Apple's developer tools.

  1. Download and unzip the latest `ProtocolBuffers-*.*-Source.tar.gz` file in the [download](http://code.google.com/p/metasyntactic/downloads/list) section to `<install_directory>` on your computer.
  1. Navigate to `<install_directory>` and type the following commands
  1. `./autogen.sh`
  1. `./configure`
  1. `make`

`protoc` will then be built into the `<install_directory>/src` directory.

## Compiler Invocation ##

For full details on the protobuf compiler, please see the official details [here](http://code.google.com/apis/protocolbuffers/docs/overview.html)

The protocol buffer compiler (`protoc`) produces Objective-C output when invoked with the `--objc_out=` command-line flag. The parameter to the `--objc_out=` option is the directory where you want the compiler to write your Objective-C output. The compiler creates a header file and an implementation file for each `.proto` file input. The names of the output files are computed by taking the name of the .proto file and making two changes:
  * The extension (`.proto`) is replaced with either `.pb.h` or `.pb.m` for the header or implementation file, respectively.
  * The proto path (specified with the `--proto_path=` or `-I` command-line flag) is replaced with the output path (specified with the `--objc_out=` flag).
So, for example, let's say you invoke the compiler as follows:
```
protoc --proto_path=src --objc_out=build/gen src/foo.proto src/bar/baz.proto
```
The compiler will read the files `src/foo.proto` and `src/bar/baz.proto` and produce four output files: `build/gen/foo.pb.h`, `build/gen/foo.pb.m`, `build/gen/bar/baz.pb.h`, `build/gen/bar/baz.pb.m`. The compiler will automatically create the directory `build/gen/bar` if necessary, but it will not create `build` or `build/gen`; they must already exist.

## Project Integration ##

Once you have generated the `.pb.h` and `.pb.m` files for the `.proto` file you care about, you can then add them to your project.  However, in order to build properly several changes must be made to your project.

  1. Download and unzip the latest `ProtocolBuffers-*.*-Source.tar.gz` file in the [download](http://code.google.com/p/metasyntactic/downloads/list) section to `<install_directory>` on your computer.  (This should have been done in the 'Creating the Protocol Buffer Compiler' step above).
  1. Open your existing project and a reference to the `ProtocolBuffers` project found in `<install_directory>`.
  1. Add a reference to `<install_directory>/Classes/ProtocolBuffers.h` in your project and add the following line to your pch file: `#import "ProtocolBuffers.h"`
  1. `Get Info` on your build target
  1. Add `ProtocolBuffers` as a `Direct Dependency` of your build target.
  1. Add `libProtocolBuffers.a` as a `Linked Library` of your build target.  You may have to do this by dragging and dropping the library from the referenced `ProtocolBuffers` project to your target's `Link Binary With Libraries` section.
  1. Compile and enjoy!


# Extensions #

In order to more seamlessly integrate with Objective-C code, this library also extends the standard google.protobuf.FileOptions message with the following options:

```
  // Sets the ObjectiveC package where classes generated from this .proto
  // will be placed.  This is typically used since Objective C libraries output
  // all their headers into a single directory.  i.e.  Foundation\*
  // AddressBook\*   UIKit\*   etc. etc.
  optional string package = 1;
  
  // The string to be prefixed in front of all classes in order to make them
  // 'cocoa-y'.  i.e. 'NS/AB/CF/PB' for the
  // NextStep/AddressBook/CoreFoundation/ProtocolBuffer libraries respectively.
  // This will commonly be the capitalized letters from the above defined
  // 'objectivec_directory'
  optional string class_prefix = 2;
```

To use these extensions you will need to add the following to your proto file:

```
import "google/protobuf/objectivec-descriptor.proto";

option (google.protobuf.objectivec_file_options).package = "<your package>"
option (google.protobuf.objectivec_file_options).class_prefix = "<your class prefix>";
```

(note that the parent folder to 'google/protobuf/objectivec-descriptor.proto' must be in your include path when compiling your protocol buffer).

By using these options, you can integrate existing protobuf definitions, while still producing Objective-C code that meets expected styling standards.  For example, this library uses those options above to emit the core protobuf Descriptor types into a "ProtocolBuffers" directory with a common "PB" prefix on all classes.  Thus, while you would say the following in java:

`import google.protobuf.Descriptor;`

in Objective-C you would say:

`import "ProtocolBuffers\PBDescriptor.h"`

# Example #

Here's an example of how I integrate the library into my own 'Now Playing' application.  Note the reference to the project, the direct dependency in the target, and the shared lib in the link section.

![http://metasyntactic.googlecode.com/svn/trunk/protobuf-2.2.0/objectivec/Documentation/XCode.png](http://metasyntactic.googlecode.com/svn/trunk/protobuf-2.2.0/objectivec/Documentation/XCode.png)

# Help/Support #

If you need any help/support with this feel free to email me at cyrus.najmabadi@gmail.com.

Cheers!