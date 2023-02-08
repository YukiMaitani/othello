import 'package:adaptive_dialog/adaptive_dialog.dart';
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
        padding: const EdgeInsets.all(20.0),
        child: _buildBody(),
      ),
      backgroundColor: const Color(0xFFFEFFDF),
    );
  }

  Widget _buildBody() {
    return HookConsumer(builder: (context, ref, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGameInformation(),
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
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF008000),
              border: Border.all(color: Colors.black)),
          child: Center(
            child: _buildDisk(disk, isPossiblePlaceDisk),
          ),
        ),
        onTap: () {
          if (isPossiblePlaceDisk) {
            final gameReader = ref.read(gameProvider);
            gameReader.placeDisk(disk);
            gameReader.turnOverDisks(disk);
            if(!gameReader.isHavePossiblePlaceDiskSquare) {
              showOkAlertDialog(
                context: context,
                message: '置けるマスがない為ターンをスキップします。',
              );
            }
            gameReader.switchTurn();
          }
        },
      );
    });
  }

  Widget _buildDisk(Disk disk, bool isPossiblePlaceDisk) {
    final Color diskColor;
    switch (disk.diskType) {
      case DiskType.none:
        return isPossiblePlaceDisk
            ? const Text(
                '・',
                style: TextStyle(fontSize: 24, color: Colors.yellow),
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
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: diskColor, borderRadius: BorderRadius.circular(50)),
    );
  }

  Widget _buildGameInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 3, child: _buildPlayerInformation(Turn.white)),
        const Spacer(
          flex: 2,
        ),
        Expanded(flex: 3, child: _buildPlayerInformation(Turn.black))
      ],
    );
  }

  Widget _buildPlayerInformation(Turn player) {
    return HookConsumer(builder: (context, ref, child) {
      final isTurnPlayer =
          ref.watch(gameProvider.select((value) => value.turn)) == player;
      final int disksNumber;
      switch (player) {
        case Turn.black:
          disksNumber =
              ref.watch(gameProvider.select((value) => value.blackDisksNumber));
          break;
        case Turn.white:
          disksNumber =
              ref.watch(gameProvider.select((value) => value.whiteDisksNumber));
          break;
      }

      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: isTurnPlayer ? Colors.redAccent : Colors.black,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: player.color,
                    border: Border.all(color: Colors.white, width: 1.5)),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                disksNumber.toString(),
                style: const TextStyle(color: Color(0xFFFEFFDF), fontSize: 24),
              ),
            ),
          ],
        ),
      );
    });
  }
}
