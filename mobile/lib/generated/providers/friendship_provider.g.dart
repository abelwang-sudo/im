// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../providers/friendship_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingFriendRequestsHash() =>
    r'd5f4f5d59b62cc40512c46d7f4256a318a919de4';

/// See also [pendingFriendRequests].
@ProviderFor(pendingFriendRequests)
final pendingFriendRequestsProvider =
    AutoDisposeFutureProvider<List<FriendshipModel>>.internal(
  pendingFriendRequests,
  name: r'pendingFriendRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingFriendRequestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingFriendRequestsRef
    = AutoDisposeFutureProviderRef<List<FriendshipModel>>;
String _$contactHash() => r'0e31382623a95d3f8d8b160fb11d128c6445f640';

/// See also [Contact].
@ProviderFor(Contact)
final contactProvider = NotifierProvider<Contact, List<ContactModel>>.internal(
  Contact.new,
  name: r'contactProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$contactHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Contact = Notifier<List<ContactModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
