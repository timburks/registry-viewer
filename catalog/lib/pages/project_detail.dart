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

import 'package:flutter/material.dart';
import '../models/selection.dart';
import '../components/project_detail.dart';
import '../components/api_list.dart';
import '../components/api_detail.dart';
import '../components/labels_list.dart';
import '../components/properties_list.dart';

class ProjectDetailPage extends StatelessWidget {
  final String name;
  ProjectDetailPage({this.name});

  @override
  Widget build(BuildContext context) {
    final Selection selection = Selection();
    Future.delayed(const Duration(), () {
      selection.updateProjectName(name.substring(1));
    });

    return SelectionProvider(
      selection: selection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Project Details",
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(child: ProjectDetailCard(editable: true)),
                  Expanded(child: LabelsCard(SelectionProvider.project)),
                  Expanded(child: PropertiesCard(SelectionProvider.project)),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(children: [
                Expanded(
                  child: SizedBox.expand(child: ApiListCard()),
                ),
                Expanded(
                  child: SizedBox.expand(child: ApiDetailCard(selflink: true)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
