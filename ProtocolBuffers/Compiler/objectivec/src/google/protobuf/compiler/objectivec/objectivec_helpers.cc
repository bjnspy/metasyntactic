// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: kenton@google.com (Kenton Varda)
//  Based on original Protocol Buffers design by
//  Sanjay Ghemawat, Jeff Dean, and others.

#include <vector>

#include <google/protobuf/stubs/hash.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>

namespace google { namespace protobuf { namespace compiler { namespace objectivec {
  namespace {
    const string& FieldName(const FieldDescriptor* field) {
      // Groups are hacky:  The name of the field is just the lower-cased name
      // of the group type.  In ObjectiveC, though, we would like to retain the original
      // capitalization of the type name.
      if (field->type() == FieldDescriptor::TYPE_GROUP) {
        return field->message_type()->name();
      } else {
        return field->name();
      }
    }


    string UnderscoresToCamelCaseImpl(const string& input, bool cap_next_letter) {
      string result;
      // Note:  I distrust ctype.h due to locales.
      for (int i = 0; i < input.size(); i++) {
        if ('a' <= input[i] && input[i] <= 'z') {
          if (cap_next_letter) {
            result += input[i] + ('A' - 'a');
          } else {
            result += input[i];
          }
          cap_next_letter = false;
        } else if ('A' <= input[i] && input[i] <= 'Z') {
          if (i == 0 && !cap_next_letter) {
            // Force first letter to lower-case unless explicitly told to
            // capitalize it.
            result += input[i] + ('a' - 'A');
          } else {
            // Capital letters after the first are left as-is.
            result += input[i];
          }
          cap_next_letter = false;
        } else if ('0' <= input[i] && input[i] <= '9') {
          result += input[i];
          cap_next_letter = true;
        } else {
          cap_next_letter = true;
        }
      }
      return result;
    }
  }


  string UnderscoresToCamelCase(const FieldDescriptor* field) {
    return UnderscoresToCamelCaseImpl(FieldName(field), false);
  }


  string UnderscoresToCapitalizedCamelCase(const FieldDescriptor* field) {
    return UnderscoresToCamelCaseImpl(FieldName(field), true);
  }


  string UnderscoresToCamelCase(const MethodDescriptor* method) {
    return UnderscoresToCamelCaseImpl(method->name(), false);
  }


  string StripProto(const string& filename) {
    if (HasSuffixString(filename, ".protodevel")) {
      return StripSuffixString(filename, ".protodevel");
    } else {
      return StripSuffixString(filename, ".proto");
    }
  }


  string FileName(const FileDescriptor* file) {
    string basename;

    string::size_type last_slash = file->name().find_last_of('/');
    if (last_slash == string::npos) {
      basename += file->name();
    } else {
      basename += file->name().substr(last_slash + 1);
    }

    return UnderscoresToCamelCaseImpl(StripProto(basename), true);
  }


  string FilePath(const FileDescriptor* file) {
    string path = FileName(file);

    if (file->options().objectivec_package() != "") {
      path = file->options().objectivec_package() + "/" + path;
    }

    return path;
  }


  string FileClassName(const FileDescriptor* file) {
    return
      file->options().objectivec_class_prefix() +
      FileName(file) +
      "Root";
  }


  string ToObjectiveCName(const string& full_name, const FileDescriptor* file) {
    string result;
    result += file->options().objectivec_class_prefix();
    result += full_name;
    return result;
  }


  string ClassNameWorker(const Descriptor* descriptor) {
    string name;
    if (descriptor->containing_type() != NULL) {
      name = ClassNameWorker(descriptor->containing_type());
      name += "_";
    }
    return name + descriptor->name();
  }


  string ClassNameWorker(const EnumDescriptor* descriptor) {
    string name;
    if (descriptor->containing_type() != NULL) {
      name = ClassNameWorker(descriptor->containing_type());
      name += "_";
    }
    return name + descriptor->name();
  }
  

  string ClassName(const Descriptor* descriptor) {
    string name = descriptor->file()->options().objectivec_class_prefix();
    name += ClassNameWorker(descriptor);
    return name;
  }


  string ClassName(const EnumDescriptor* descriptor) {
    string name = descriptor->file()->options().objectivec_class_prefix();
    name += ClassNameWorker(descriptor);
    return name;
  }


  string ClassName(const ServiceDescriptor* descriptor) {
    string name = descriptor->file()->options().objectivec_class_prefix();
    name += descriptor->name();
    return name;
  }


  ObjectiveCType GetObjectiveCType(FieldDescriptor::Type field_type) {
    switch (field_type) {
    case FieldDescriptor::TYPE_INT32:
    case FieldDescriptor::TYPE_UINT32:
    case FieldDescriptor::TYPE_SINT32:
    case FieldDescriptor::TYPE_FIXED32:
    case FieldDescriptor::TYPE_SFIXED32:
      return OBJECTIVECTYPE_INT;

    case FieldDescriptor::TYPE_INT64:
    case FieldDescriptor::TYPE_UINT64:
    case FieldDescriptor::TYPE_SINT64:
    case FieldDescriptor::TYPE_FIXED64:
    case FieldDescriptor::TYPE_SFIXED64:
      return OBJECTIVECTYPE_LONG;

    case FieldDescriptor::TYPE_FLOAT:
      return OBJECTIVECTYPE_FLOAT;

    case FieldDescriptor::TYPE_DOUBLE:
      return OBJECTIVECTYPE_DOUBLE;

    case FieldDescriptor::TYPE_BOOL:
      return OBJECTIVECTYPE_BOOLEAN;

    case FieldDescriptor::TYPE_STRING:
      return OBJECTIVECTYPE_STRING;

    case FieldDescriptor::TYPE_BYTES:
      return OBJECTIVECTYPE_DATA;

    case FieldDescriptor::TYPE_ENUM:
      return OBJECTIVECTYPE_ENUM;

    case FieldDescriptor::TYPE_GROUP:
    case FieldDescriptor::TYPE_MESSAGE:
      return OBJECTIVECTYPE_MESSAGE;
    }

    GOOGLE_LOG(FATAL) << "Can't get here.";
    return OBJECTIVECTYPE_INT;
  }


  const char* BoxedPrimitiveTypeName(ObjectiveCType type) {
    switch (type) {
    case OBJECTIVECTYPE_INT    : return "NSNumber";
    case OBJECTIVECTYPE_LONG   : return "NSNumber";
    case OBJECTIVECTYPE_FLOAT  : return "NSNumber";
    case OBJECTIVECTYPE_DOUBLE : return "NSNumber";
    case OBJECTIVECTYPE_BOOLEAN: return "NSNumber";
    case OBJECTIVECTYPE_STRING : return "NSString";
    case OBJECTIVECTYPE_DATA   : return "NSData";
    case OBJECTIVECTYPE_ENUM   : return NULL;
    case OBJECTIVECTYPE_MESSAGE: return NULL;
    }

    GOOGLE_LOG(FATAL) << "Can't get here.";
    return NULL;
  }


  bool IsPrimitiveType(ObjectiveCType type) {
    switch (type) {
    case OBJECTIVECTYPE_INT    :
    case OBJECTIVECTYPE_LONG   :
    case OBJECTIVECTYPE_FLOAT  :
    case OBJECTIVECTYPE_DOUBLE :
    case OBJECTIVECTYPE_BOOLEAN:
      return true;
    }

    return false;
  }


  bool IsReferenceType(ObjectiveCType type) {
    return !IsPrimitiveType(type);
  }


  bool ReturnsPrimitiveType(const FieldDescriptor* field) {
    return IsPrimitiveType(GetObjectiveCType(field->type()));
  }


  bool ReturnsReferenceType(const FieldDescriptor* field) {
    return !ReturnsPrimitiveType(field);
  }


  namespace {
    string DotsToUnderscores(const string& name) {
      return StringReplace(name, ".", "_", true);
    }

    const char* const kKeywordList[] = {
      "TYPE_BOOL"
    };


    hash_set<string> MakeKeywordsMap() {
      hash_set<string> result;
      for (int i = 0; i < GOOGLE_ARRAYSIZE(kKeywordList); i++) {
        result.insert(kKeywordList[i]);
      }
      return result;
    }

    hash_set<string> kKeywords = MakeKeywordsMap();
  } 


  string SafeName(const string& name) {
    string result = name;
    if (kKeywords.count(result) > 0) {
      result.append("_");
    }
    return result;
  }
}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google