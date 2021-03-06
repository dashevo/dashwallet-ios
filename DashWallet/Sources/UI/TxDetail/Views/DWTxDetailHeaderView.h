//
//  Created by Andrew Podkovyrin
//  Copyright © 2019 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

#import "DWTxDetailDisplayType.h"

NS_ASSUME_NONNULL_BEGIN

@class DWTxDetailModel;
@class DWTxDetailHeaderView;

@protocol DWTxDetailHeaderViewDelegate <NSObject>

- (void)txDetailHeaderView:(DWTxDetailHeaderView *)view viewInExplorerAction:(UIButton *)sender;

@end

@interface DWTxDetailHeaderView : UIView

@property (nonatomic, assign) DWTxDetailDisplayType displayType;
@property (nullable, nonatomic, strong) DWTxDetailModel *model;
@property (nullable, nonatomic, weak) id<DWTxDetailHeaderViewDelegate> delegate;

- (void)viewDidAppear;

- (void)setViewInExplorerButtonCopyHintTitle;

- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
