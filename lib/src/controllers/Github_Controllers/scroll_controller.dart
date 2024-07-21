// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/src/controllers/Github_Controllers/github_list_controller.dart';

class ScrollStateNotifier extends StateNotifier<void> {
  final VoidCallback _onScrollEnd;
  ScrollStateNotifier(this._onScrollEnd) : super(null);
  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _onScrollEnd();
    }
  }

  void init() {
    scrollController.addListener(_scrollListener);
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
  }
}

final scrollStateProvider =
    StateNotifierProvider<ScrollStateNotifier, void>((ref) {
  void onScrollEnd() {
    ref.read(repositoryNotifierProvider.notifier).incrementPageCount();
  }

  final notifier = ScrollStateNotifier(onScrollEnd);
  ref.onDispose(notifier.dispose);
  notifier.init();
  return notifier;
});
