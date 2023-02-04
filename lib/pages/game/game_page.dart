import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GamePage extends HookConsumerWidget {
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
          _buildBord(),
        ],
      );
    });
  }

  Widget _buildBord() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 8,
      children: [_buildSquare()],
    );
  }

  Widget _buildSquare() {
    return HookConsumer(builder: (context, ref, child) {
      final baseWidth = MediaQuery.of(context).size.width * 0.9;
      final squareWidth = baseWidth / 8;
      return Container(
        width: squareWidth,
        height: squareWidth,
        decoration: BoxDecoration(
            color: const Color(0xFF008000),
            border: Border.all(color: Colors.black)),
        child: Center(child: _buildDisk(squareWidth)),
      );
    });
  }

  Widget _buildDisk(double squareWidth) {
    final diskWidth = squareWidth * 0.8;
    return Container(
      width: diskWidth,
      height: diskWidth,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(50)),
    );
  }
}
