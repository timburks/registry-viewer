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

import 'package:registry/generated/google/cloud/apigee/registry/v1alpha1/registry_models.pb.dart';

extension Display on Version {
  String nameForDisplay() {
    if (this.displayName != "") {
      return this.displayName;
    } else {
      return this.name.split("/").last;
    }
  }

  String stateForDisplay() {
    if (this.state != "") {
      return this.state;
    }
    return "available";
  }

  String routeNameForDetail() {
    return "/" + this.name;
  }

  String routeNameForSpecs() {
    return "/" + this.name + "/specs";
  }
}
