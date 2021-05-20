// Copyright 2021 Google LLC. All Rights Reserved.
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

import 'package:args/command_runner.dart';
import 'import-asyncapi-directory.dart';
import 'import-common-protos.dart';
import 'import-discovery.dart';
import 'import-googleapis.dart';
import 'import-openapi-directory.dart';

class ImportCommand extends Command {
  final name = "import";
  final description = "Import API descriptions.";

  ImportCommand() {
    this.addSubcommand(ImportAsyncAPIDirectoryCommand());
    this.addSubcommand(ImportCommonProtosCommand());
    this.addSubcommand(ImportDiscoveryCommand());
    this.addSubcommand(ImportGoogleAPIsCommand());
    this.addSubcommand(ImportOpenAPIDirectoryCommand());
  }
}