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

#import "EditorViewController.h"

@interface TextFieldEditorViewController : EditorViewController<UITextFieldDelegate> {
    UITextField* textField;
    UILabel* messageLabel;
}

@property (retain) UITextField* textField;
@property (retain) UILabel* messageLabel;

- (id) initWithController:(AbstractNavigationController*) navigationController
                    title:(NSString*) title
                   object:(id) object
                 selector:(SEL) selector
                     text:(NSString*) text
                  message:(NSString*) message
              placeHolder:(NSString*) placeHolder
                     type:(UIKeyboardType) type;

@end