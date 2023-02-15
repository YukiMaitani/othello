import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:othello/foundation/enum.dart';
import 'package:othello/pages/game/board_painter.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 5,
          ),
          _buildGameInformation(),
          const Spacer(),
          _buildBoard(),
          const Spacer(
            flex: 2,
          ),
          _buildInitializationButton(),
          const Spacer(
            flex: 2,
          ),
        ],
      );
    });
  }

  Widget _buildBoard() {
    return HookConsumer(builder: (context, ref, child) {
      final disksList =
          ref.watch(gameProvider.select((value) => value.disksFlatten));
      final baseWidth = MediaQuery.of(context).size.width - 20;
      return GestureDetector(
        child: Container(
          height: baseWidth,
          width: baseWidth,
          color: const Color(0xFF008000),
          child: CustomPaint(
            painter: BoardPainter(disksList),
          ),
        ),
        onTapDown: (value) {
          final row = ((value.localPosition.dx / baseWidth) * 8).toInt();
          final column = ((value.localPosition.dy / baseWidth) * 8).toInt();
          final tappedDisk = ref.read(gameProvider).disks[column][row];
          if (tappedDisk.isPlaceable) {
            ref.read(gameProvider).onePlay(tappedDisk);
            final result = ref.read(gameProvider).switchTurn();
            Logger().i(result);
            switch (result) {
              case Result.proceed:
                break;
              case Result.pass:
                showOkAlertDialog(
                  context: context,
                  message: '置けるマスがない為ターンをスキップします。',
                );
                final passedResult = ref.read(gameProvider).switchTurn();
                if(passedResult == Result.pass) {
                  final gameResult = ref.read(gameProvider).gameResult;
                  showOkAlertDialog(
                    context: context,
                    message: 'お互いに置けるマスがありません。\n$gameResult',
                  );
                }
                break;
              case Result.filled:
                final gameResult = ref.read(gameProvider).gameResult;
                showOkAlertDialog(
                  context: context,
                  message: '全てのマスが埋まりました。\n$gameResult',
                );
                break;
            }
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

  Widget _buildInitializationButton() {
    return HookConsumer(builder: (context, ref, child) {
      return Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
            onPressed: () async {
              final willInitialization = await showOkCancelAlertDialog(
                  context: context,
                  message: '新規対局を開始しますか？',
                  okLabel: '開始',
                  cancelLabel: 'キャンセル');
              switch (willInitialization) {
                case OkCancelResult.ok:
                  ref.read(gameProvider).initDisksType();
                  break;
                case OkCancelResult.cancel:
                  break;
              }
            },
            child: const SizedBox(
              width: 120,
              height: 40,
              child: Center(
                child: Text(
                  '新規対局',
                ),
              ),
            )),
      );
    });
  }
}
