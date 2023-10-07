import 'package:flutter/material.dart';
import 'package:post_app/models/draft_model.dart';

class DraftProvider extends ChangeNotifier {
  Draft? _draft;
  bool _isSaved = false;

  Draft? get draft => _draft;
  bool get isSaved => _isSaved;

  void createDraft(Draft draft) {
    _draft = draft;
    _isSaved = true;
    notifyListeners();
  }

  void removeDraft() {
    _draft = null;
    _isSaved = false;
    notifyListeners();
  }
}
