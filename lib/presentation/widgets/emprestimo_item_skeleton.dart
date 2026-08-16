import 'package:flutter/material.dart';
import 'package:gardien_tech/utils/cores_gardien.dart';
import 'package:shimmer/shimmer.dart';

class EmprestimoDetalheSkeleton extends StatelessWidget {
  const EmprestimoDetalheSkeleton({super.key});

  Widget _item({double? width, required double height, BorderRadius? radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: CoresGardien.branco,
        borderRadius: radius ?? BorderRadius.circular(8),
      ),
    );
  }

  Widget _card() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _item(height: 48)),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _item(height: 48)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _item(width: 90, height: 20),
                const SizedBox(width: 12),
                _item(width: 24, height: 24),
                const Spacer(),
                _item(width: 120, height: 36, radius: BorderRadius.circular(8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Shimmer.fromColors(
        baseColor: CoresGardien.branco,
        highlightColor: CoresGardien.branco,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: List.generate(6, (_) => _card())),
        ),
      ),
    );
  }
}
