import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:othello/pages/game/game_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: GamePage()
    );
  }
}