import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:othello/foundation/enum.dart';
import 'package:othello/pages/game/game_view_model.dart';

import '../../model/disk.dart';

class GamePage extends HookConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return HookConsumer(builder: (context, ref, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBoard(),
        ],
      );
    });
  }

  Widget _buildBoard() {
    return HookConsumer(builder: (context, ref, child) {
      final disksList =
          ref.watch(gameProvider.select((value) => value.disksFlatten));
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 8,
        children: disksList.map((disk) => _buildSquare(disk)).toList(),
      );
    });
  }

  Widget _buildSquare(Disk disk) {
    return HookConsumer(builder: (context, ref, child) {
      final isPossiblePlaceDisk = ref.watch(
          gameProvider.select((value) => value.isPossiblePlaceDisk(disk)));
      final baseWidth = MediaQuery.of(context).size.width * 0.9;
      final squareWidth = baseWidth / 8;
      return GestureDetector(
        child: Container(
          width: squareWidth,
          height: squareWidth,
          decoration: BoxDecoration(
              color: const Color(0xFF008000),
              border: Border.all(color: Colors.black)),
          child: Center(
            child: _buildDisk(squareWidth, disk, isPossiblePlaceDisk),
          ),
        ),
      );
    });
  }

  Widget _buildDisk(double squareWidth, Disk disk, bool isPossiblePlaceDisk) {
    final diskWidth = squareWidth * 0.8;
    final Color diskColor;
    switch (disk.diskType) {
      case DiskType.none:
        return isPossiblePlaceDisk
            ? const Text(
                '・',
                style: TextStyle(fontSize: 20, color: Colors.yellow),
              )
            : const SizedBox();

      case DiskType.black:
        diskColor = Colors.black;
        break;
      case DiskType.white:
        diskColor = Colors.white;
        break;
    }
    return Container(
      width: diskWidth,
      height: diskWidth,
      decoration: BoxDecoration(
          color: diskColor, borderRadius: BorderRadius.circular(50)),
    );
  }
}
