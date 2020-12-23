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
import 'package:registry/generated/google/cloud/apigee/registry/v1alpha1/registry_models.pb.dart';
import 'package:registry/generated/metrics/vocabulary.pb.dart';
import '../components/detail_rows.dart';
import '../helpers/extensions.dart';

class VocabularyPropertyCard extends StatelessWidget {
  final Property property;
  final Function selflink;
  VocabularyPropertyCard(this.property, {this.selflink});

  Widget build(BuildContext context) {
    Vocabulary vocabulary =
        new Vocabulary.fromBuffer(property.messageValue.value);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResourceNameButtonRow(
            name: property.name.last(1),
            show: selflink,
            edit: null,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: WordCountListCard("schemas", vocabulary.schemas),
                ),
                VerticalDivider(width: 7),
                Expanded(
                  child: WordCountListCard("properties", vocabulary.properties),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: WordCountListCard("operations", vocabulary.operations),
                ),
                VerticalDivider(width: 7),
                Expanded(
                  child: WordCountListCard("parameters", vocabulary.parameters),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WordCountListCard extends StatefulWidget {
  final String name;
  final List<WordCount> wordCountList;
  WordCountListCard(this.name, this.wordCountList);

  @override
  WordCountListCardState createState() => WordCountListCardState();
}

class WordCountListCardState extends State<WordCountListCard> {
  final ScrollController controller = ScrollController();

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          width: double.infinity,
          color: Theme.of(context).splashColor,
          child: Text(
            "${widget.name} (${widget.wordCountList.length})",
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: controller,
            child: ListView.builder(
              controller: controller,
              itemCount: widget.wordCountList.length,
              itemBuilder: (BuildContext context, int index) {
                final wordCount = widget.wordCountList[index];
                return Row(
                  children: [
                    Container(
                      width: 40,
                      child: Text(
                        "${wordCount.count}",
                        textAlign: TextAlign.end,
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        wordCount.word,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}