// Copyright 2020 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:intl/intl.dart';
import 'package:catalog/generated/google/protobuf/timestamp.pb.dart';

String format(Timestamp t) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
  return formatter.format(DateTime.fromMillisecondsSinceEpoch(
      t.seconds.toInt() * 1000,
      isUtc: false));
}