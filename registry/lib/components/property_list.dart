// Copyright 2020 Google LLC. All Rights Reserved.
//
// Licensed under the Apache License, Property 2.0 (the "License");
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
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:registry/generated/google/cloud/apigee/registry/v1alpha1/registry_models.pb.dart';
import '../service/service.dart';
import '../models/property.dart';
import '../models/string.dart';
import '../models/selection.dart';
import 'custom_search_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'filter.dart';
import 'property_add.dart';

const int pageSize = 50;

typedef ObservableStringFn = ObservableString Function(BuildContext context);

typedef PropertySelectionHandler = Function(
    BuildContext context, Property property);

PagewiseLoadController<Property> pageLoadController; // hack

// PropertyListCard is a card that displays a list of properties.
class PropertyListCard extends StatefulWidget {
  final ObservableStringFn getObservableResourceName;
  PropertyListCard(this.getObservableResourceName);

  @override
  _PropertyListCardState createState() => _PropertyListCardState();
}

class _PropertyListCardState extends State<PropertyListCard> {
  ObservableString subjectNameManager;
  String subjectName;

  String projectName() {
    return subjectName.split("/").sublist(0, 2).join("/");
  }

  void listener() {
    pageLoadController?.reset();
    setState(() {
      subjectName = subjectNameManager.value;
      if (subjectName == null) {
        subjectName = "";
      }
    });
  }

  @override
  void didChangeDependencies() {
    subjectNameManager = widget.getObservableResourceName(context);
    subjectNameManager.addListener(listener);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Function add = () {
      final selection = SelectionProvider.of(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SelectionProvider(
              selection: selection,
              child: AlertDialog(
                content: AddPropertyForm(subjectName),
              ),
            );
          });
    };
    return ObservableStringProvider(
      observable: ObservableString(),
      child: Card(
        child: Column(
          children: [
            filterBar(context, PropertySearchBox(),
                type: "properties", add: add),
            Expanded(
              child: PropertyListView(widget.getObservableResourceName, null),
            ),
          ],
        ),
      ),
    );
  }
}

// PropertyListView is a scrollable ListView of properties.
class PropertyListView extends StatefulWidget {
  final ObservableStringFn getObservableResourceName;
  final PropertySelectionHandler selectionHandler;
  PropertyListView(this.getObservableResourceName, this.selectionHandler);
  @override
  _PropertyListViewState createState() => _PropertyListViewState();
}

class _PropertyListViewState extends State<PropertyListView> {
  String parentName;
  //PagewiseLoadController<Property> pageLoadController;
  PropertyService propertyService;
  int selectedIndex = -1;

  _PropertyListViewState() {
    propertyService = PropertyService();
    pageLoadController = PagewiseLoadController<Property>(
        pageSize: pageSize,
        pageFuture: (pageIndex) =>
            propertyService.getPropertiesPage(pageIndex));
  }

  @override
  void didChangeDependencies() {
    ObservableStringProvider.of(context).addListener(() => setState(() {
          ObservableString filter = ObservableStringProvider.of(context);
          if (filter != null) {
            propertyService.filter = filter.value;
            pageLoadController.reset();
            selectedIndex = -1;
          }
        }));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    propertyService.context = context;
    String subjectName = widget.getObservableResourceName(context).value;
    if (propertyService.parentName != subjectName) {
      propertyService.parentName = subjectName;
      pageLoadController.reset();
      selectedIndex = -1;
    }
    return Scrollbar(
      child: PagewiseListView<Property>(
        itemBuilder: this._itemBuilder,
        pageLoadController: pageLoadController,
      ),
    );
  }

  Widget widgetForPropertyValue(Property property) {
    if (property.hasStringValue()) {
      final value = property.stringValue;

      return Linkify(
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw 'Could not launch $link';
          }
        },
        text: value,
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyText1,
        linkStyle:
            Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue),
      );
    }
    if (property.hasMessageValue()) {
      return Text(
        property.messageValue.typeUrl,
        textAlign: TextAlign.right,
      );
    }
    return Text("");
  }

  Widget _itemBuilder(context, Property property, index) {
    return ListTile(
      title: Text(property.nameForDisplay()),
      subtitle: widgetForPropertyValue(property),
      selected: index == selectedIndex,
      dense: false,
      onTap: () async {
        setState(() {
          selectedIndex = index;
        });
        Selection selection = SelectionProvider.of(context);
        selection?.updatePropertyName(property.name);
        widget.selectionHandler?.call(context, property);
      },
    );
  }
}

// PropertySearchBox provides a search box for properties.
class PropertySearchBox extends CustomSearchBox {
  PropertySearchBox()
      : super("Filter Properties", "property_id.contains('TEXT')");
}