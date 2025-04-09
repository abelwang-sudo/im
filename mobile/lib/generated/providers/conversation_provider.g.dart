// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../providers/conversation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$joinRequestsHash() => r'6c2ce161083a82d13a3faa1279d3ac749bce12a5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [joinRequests].
@ProviderFor(joinRequests)
const joinRequestsProvider = JoinRequestsFamily();

/// See also [joinRequests].
class JoinRequestsFamily extends Family<AsyncValue<List<JoinRequestModel>>> {
  /// See also [joinRequests].
  const JoinRequestsFamily();

  /// See also [joinRequests].
  JoinRequestsProvider call(
    int conversationId,
  ) {
    return JoinRequestsProvider(
      conversationId,
    );
  }

  @override
  JoinRequestsProvider getProviderOverride(
    covariant JoinRequestsProvider provider,
  ) {
    return call(
      provider.conversationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'joinRequestsProvider';
}

/// See also [joinRequests].
class JoinRequestsProvider
    extends AutoDisposeFutureProvider<List<JoinRequestModel>> {
  /// See also [joinRequests].
  JoinRequestsProvider(
    int conversationId,
  ) : this._internal(
          (ref) => joinRequests(
            ref as JoinRequestsRef,
            conversationId,
          ),
          from: joinRequestsProvider,
          name: r'joinRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinRequestsHash,
          dependencies: JoinRequestsFamily._dependencies,
          allTransitiveDependencies:
              JoinRequestsFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  JoinRequestsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conversationId,
  }) : super.internal();

  final int conversationId;

  @override
  Override overrideWith(
    FutureOr<List<JoinRequestModel>> Function(JoinRequestsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinRequestsProvider._internal(
        (ref) => create(ref as JoinRequestsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conversationId: conversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JoinRequestModel>> createElement() {
    return _JoinRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinRequestsProvider &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JoinRequestsRef on AutoDisposeFutureProviderRef<List<JoinRequestModel>> {
  /// The parameter `conversationId` of this provider.
  int get conversationId;
}

class _JoinRequestsProviderElement
    extends AutoDisposeFutureProviderElement<List<JoinRequestModel>>
    with JoinRequestsRef {
  _JoinRequestsProviderElement(super.provider);

  @override
  int get conversationId => (origin as JoinRequestsProvider).conversationId;
}

String _$conversationControllerHash() =>
    r'3804176c71f4bca6ffde7356d17324d96e1667bf';

/// 会话列表状态提供者
///
/// Copied from [ConversationController].
@ProviderFor(ConversationController)
final conversationControllerProvider =
    NotifierProvider<ConversationController, List<ConversationModel>>.internal(
  ConversationController.new,
  name: r'conversationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConversationController = Notifier<List<ConversationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
