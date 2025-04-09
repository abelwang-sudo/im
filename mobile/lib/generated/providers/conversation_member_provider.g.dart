// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../providers/conversation_member_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationMembersHash() =>
    r'53b5c198514b541cf54ba2ef70cb6d964ed54b5d';

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

abstract class _$ConversationMembers
    extends BuildlessNotifier<List<ConversationMemberModel>> {
  late final int conversationId;

  List<ConversationMemberModel> build(
    int conversationId,
  );
}

/// See also [ConversationMembers].
@ProviderFor(ConversationMembers)
const conversationMembersProvider = ConversationMembersFamily();

/// See also [ConversationMembers].
class ConversationMembersFamily extends Family<List<ConversationMemberModel>> {
  /// See also [ConversationMembers].
  const ConversationMembersFamily();

  /// See also [ConversationMembers].
  ConversationMembersProvider call(
    int conversationId,
  ) {
    return ConversationMembersProvider(
      conversationId,
    );
  }

  @override
  ConversationMembersProvider getProviderOverride(
    covariant ConversationMembersProvider provider,
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
  String? get name => r'conversationMembersProvider';
}

/// See also [ConversationMembers].
class ConversationMembersProvider extends NotifierProviderImpl<
    ConversationMembers, List<ConversationMemberModel>> {
  /// See also [ConversationMembers].
  ConversationMembersProvider(
    int conversationId,
  ) : this._internal(
          () => ConversationMembers()..conversationId = conversationId,
          from: conversationMembersProvider,
          name: r'conversationMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationMembersHash,
          dependencies: ConversationMembersFamily._dependencies,
          allTransitiveDependencies:
              ConversationMembersFamily._allTransitiveDependencies,
          conversationId: conversationId,
        );

  ConversationMembersProvider._internal(
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
  List<ConversationMemberModel> runNotifierBuild(
    covariant ConversationMembers notifier,
  ) {
    return notifier.build(
      conversationId,
    );
  }

  @override
  Override overrideWith(ConversationMembers Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConversationMembersProvider._internal(
        () => create()..conversationId = conversationId,
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
  NotifierProviderElement<ConversationMembers, List<ConversationMemberModel>>
      createElement() {
    return _ConversationMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMembersProvider &&
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
mixin ConversationMembersRef
    on NotifierProviderRef<List<ConversationMemberModel>> {
  /// The parameter `conversationId` of this provider.
  int get conversationId;
}

class _ConversationMembersProviderElement extends NotifierProviderElement<
    ConversationMembers,
    List<ConversationMemberModel>> with ConversationMembersRef {
  _ConversationMembersProviderElement(super.provider);

  @override
  int get conversationId =>
      (origin as ConversationMembersProvider).conversationId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
