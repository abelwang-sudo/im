import 'package:im_mobile/models/conversation_member_model.dart';
import 'package:im_mobile/services/conversation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part '../generated/providers/conversation_member_provider.g.dart';

@Riverpod(keepAlive: true)
class ConversationMembers extends _$ConversationMembers {
  @override
  List<ConversationMemberModel> build(int conversationId) {
    return [];
  }

  load()async{
    final members = await ConversationService.getConversationMembers(conversationId);
    state = members;
  }

}