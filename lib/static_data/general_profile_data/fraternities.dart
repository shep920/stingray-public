import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'make_icon.dart';

class Fraternities {
  static List getFraternities() {
    List _fraternities = [
      {
        'label': 'Alpha Epsilon Pi',
        'value': 'Alpha Epsilon Pi',
      },
      {
        'label': 'Sigma Phi Delta',
        'value': 'Sigma Phi Delta',
      },
      {
        'label': 'Omega Phi Alpha',
        'value': 'Omega Phi Alpha',
      },
      {
        'label': 'Alpha Omega Epsilon',
        'value': 'Alpha Omega Epsilon',
      },
      {
        'label': 'Alpha Gamma Rho',
        'value': 'Alpha Gamma Rho',
      },
      {
        'label': 'Alpha Sigma Phi',
        'value': 'Alpha Sigma Phi',
      },
      {
        'label': 'Beta Theta Pi',
        'value': 'Beta Theta Pi',
      },
      {
        'label': 'Delta Chi ',
        'value': 'Delta Chi ',
      },
      {
        'label': 'Delta Tau Delta',
        'value': 'Delta Tau Delta',
      },
      {
        'label': 'Kappa Alpha Order',
        'value': 'Kappa Alpha Order',
      },
      {
        'label': 'Kappa Sigma',
        'value': 'Kappa Sigma',
      },
      {
        'label': 'Lambda Chi Alpha',
        'value': 'Lambda Chi Alpha',
      },
      {
        'label': 'Phi Delta Theta',
        'value': 'Phi Delta Theta',
      },
      {
        'label': 'Phi Gamma Delta',
        'value': 'Phi Gamma Delta',
      },
      {
        'label': 'Phi Kappa Psi',
        'value': 'Phi Kappa Psi',
      },
      {
        'label': 'Phi Sigma Kappa',
        'value': 'Phi Sigma Kappa',
      },
      {
        'label': 'Phi Sigma Phi',
        'value': 'Phi Sigma Phi',
      },
      {
        'label': 'Pi Kappa Alpha',
        'value': 'Pi Kappa Alpha',
      },
      {
        'label': 'Pi Kappa Phi',
        'value': 'Pi Kappa Phi',
      },
      {
        'label': 'Pi Lambda Phi',
        'value': 'Pi Lambda Phi',
      },
      {
        'label': 'Sigma Alpha Epsilon',
        'value': 'Sigma Alpha Epsilon',
      },
      {
        'label': 'Sigma Alpha Mu',
        'value': 'Sigma Alpha Mu',
      },
      {
        'label': 'Sigma Chi',
        'value': 'Sigma Chi',
      },
      {
        'label': 'Sigma Nu',
        'value': 'Sigma Nu',
      },
      {
        'label': 'Sigma Phi Epsilon',
        'value': 'Sigma Phi Epsilon',
      },
      {
        'label': 'Tau Kappa Epsilon',
        'value': 'Tau Kappa Epsilon',
      },
      {
        'label': 'Theta Chi',
        'value': 'Theta Chi',
      },
      {
        'label': 'Alpha Phi Alpha',
        'value': 'Alpha Phi Alpha',
      },
      {
        'label': 'Alpha Kappa Alpha',
        'value': 'Alpha Kappa Alpha',
      },
      {
        'label': 'Kappa Alpha Psi',
        'value': 'Kappa Alpha Psi',
      },
      {
        'label': 'Omega Psi Phi',
        'value': 'Omega Psi Phi',
      },
      {
        'label': 'Delta Sigma Theta',
        'value': 'Delta Sigma Theta',
      },
      {
        'label': 'Phi Beta Sigma',
        'value': 'Phi Beta Sigma',
      },
      {
        'label': 'Zeta Phi Beta',
        'value': 'Zeta Phi Beta',
      },
      {
        'label': 'Alpha Omicron Pi',
        'value': 'Alpha Omicron Pi',
      },
      {
        'label': 'Alpha Phi',
        'value': 'Alpha Phi',
      },
      {
        'label': 'Alpha Xi Delta',
        'value': 'Alpha Xi Delta',
      },
      {
        'label': 'Chi Omega',
        'value': 'Chi Omega',
      },
      {
        'label': 'Delta Gamma',
        'value': 'Delta Gamma',
      },
      {
        'label': 'Kappa Kappa Gamma',
        'value': 'Kappa Kappa Gamma',
      },
      {
        'label': 'Pi Beta Phi',
        'value': 'Pi Beta Phi',
      },
      {
        'label': 'Sigma Kappa',
        'value': 'Sigma Kappa',
      },
      {
        'label': 'Sigma Males',
        'value': 'Sigma Males',
      },
      {
        'label': 'Ligma',
        'value': 'Ligma',
      },
    ];

    _fraternities.sort((a, b) => a['label'].compareTo(b['label']));

    return _fraternities;
  }

  static List<DropDownValueModel> getFraternitydropDownValueModels(
      List fraternities) {
    List<DropDownValueModel> _fraternirtyDropDownValueModels = [];
    for (var organization in fraternities) {
      _fraternirtyDropDownValueModels.add(DropDownValueModel(
          name: organization['label'], value: organization['value']));
    }
    return _fraternirtyDropDownValueModels;
  }

  static String tsFrats() {
    String _tsFrats = 'fraternity:[';
    List _frats = getFraternities();
    List<String> fratNames = [];
    for (var frat in _frats) {
      fratNames.add(frat['label']);
    }

    for (String frat in fratNames) {
      //add frat in the form 'frat,'. If it is the last frat, do 'frat]'
      if (frat == fratNames.last) {
        _tsFrats += '$frat]';
      } else {
        _tsFrats += '$frat,';
      }
    }

    return _tsFrats;
  }
}
