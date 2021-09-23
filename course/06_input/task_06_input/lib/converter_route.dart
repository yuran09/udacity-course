// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the color and units to not be null.
  const ConverterRoute({
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  var txtController = TextEditingController();
  Unit dddValue;
  Unit dddValue2;

  // TODO: Determine whether you need to override anything, such as initState()
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    txtController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    dddValue = widget.units[0];
    dddValue2 = widget.units[0];
    // Start listening to changes.
    txtController.addListener((){});
  }

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  ///Deny multiple dots after first one
  String _oneDotOnly(String outputNum){
    var ch = '.';
    if(outputNum.contains('.')){
      if (outputNum.indexOf(ch) != outputNum.lastIndexOf(ch)) {
        print(outputNum);
        return outputNum.substring(0, outputNum.length - 1);
      }
    }
    print(outputNum);
    return outputNum;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    final input = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: txtController,
            onChanged: (String value){
              // txtController.text = _oneDotOnly(value);
            },
            onSubmitted: (String value){
              setState(() {
                txtController.text = _format(double.parse(value));
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9.])'))],
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                labelText: 'Input',
                border:  OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.black38),
                  borderRadius: BorderRadius.circular(10),
                ),
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: widget.color),
                borderRadius: BorderRadius.circular(10),
              ),
                labelStyle: Theme.of(context).textTheme.bodyText1,

                // errorText:
                //     _showValidationError ? 'invalid number entered' : null,

                ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(7)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              value: dddValue,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (Unit newValue) {
                setState(() {
                  dddValue = newValue;
                });
              },
              items: widget.units.map<DropdownMenuItem<Unit>>((Unit value) {
                return DropdownMenuItem<Unit>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );



    // TODO: Create a compare arrows icon.
    final arrow = Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.compare_arrows,
          size: 40,
        ),
      ),
    );
    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].
    final output = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                labelText: 'Output',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                // errorText:
                //     _showValidationError ? 'invalid number entered' : null,
              border:  OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black38),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: widget.color),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(7)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              value: dddValue2,
              isExpanded: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (Unit newValue) {
                setState(() {
                  dddValue2 = newValue;
                });
              },
              items: widget.units.map<DropdownMenuItem<Unit>>((Unit value) {
                return DropdownMenuItem<Unit>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.

    // TODO: Delete the below placeholder code.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          input,
          SizedBox(height: 15),
          arrow,
          SizedBox(height: 15),
          output
        ],
      ),
    );
  }
}
