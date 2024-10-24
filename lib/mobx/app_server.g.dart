// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_server.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppServer on AppServerBase, Store {
  late final _$primaryColorAtom =
      Atom(name: 'AppServerBase.primaryColor', context: context);

  @override
  Color get primaryColor {
    _$primaryColorAtom.reportRead();
    return super.primaryColor;
  }

  @override
  set primaryColor(Color value) {
    _$primaryColorAtom.reportWrite(value, super.primaryColor, () {
      super.primaryColor = value;
    });
  }

  late final _$serverResponseAtom =
      Atom(name: 'AppServerBase.serverResponse', context: context);

  @override
  MainResponse get serverResponse {
    _$serverResponseAtom.reportRead();
    return super.serverResponse;
  }

  @override
  set serverResponse(MainResponse value) {
    _$serverResponseAtom.reportWrite(value, super.serverResponse, () {
      super.serverResponse = value;
    });
  }

  late final _$AppServerBaseActionController =
      ActionController(name: 'AppServerBase', context: context);

  @override
  void changePrimaryColor(Color color) {
    final _$actionInfo = _$AppServerBaseActionController.startAction(
        name: 'AppServerBase.changePrimaryColor');
    try {
      return super.changePrimaryColor(color);
    } finally {
      _$AppServerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveServerResponse(Map<String, dynamic> json) {
    final _$actionInfo = _$AppServerBaseActionController.startAction(
        name: 'AppServerBase.saveServerResponse');
    try {
      return super.saveServerResponse(json);
    } finally {
      _$AppServerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
primaryColor: ${primaryColor},
serverResponse: ${serverResponse}
    ''';
  }
}
