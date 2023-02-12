// Mocks generated by Mockito 5.3.2 from annotations
// in feedays/test/ui/search_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:feedays/domain/entities/entity.dart' as _i2;
import 'package:feedays/domain/repositories/web/web_repository_interface.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWebSite_0 extends _i1.SmartFake implements _i2.WebSite {
  _FakeWebSite_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WebRepositoryInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebRepositoryInterface extends _i1.Mock
    implements _i3.WebRepositoryInterface {
  @override
  _i4.Future<_i2.WebSite> getFeeds(_i2.WebSite? site) => (super.noSuchMethod(
        Invocation.method(
          #getFeeds,
          [site],
        ),
        returnValue: _i4.Future<_i2.WebSite>.value(_FakeWebSite_0(
          this,
          Invocation.method(
            #getFeeds,
            [site],
          ),
        )),
        returnValueForMissingStub: _i4.Future<_i2.WebSite>.value(_FakeWebSite_0(
          this,
          Invocation.method(
            #getFeeds,
            [site],
          ),
        )),
      ) as _i4.Future<_i2.WebSite>);
}
