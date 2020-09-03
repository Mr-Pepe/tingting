import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tingting/utils/generateDiffGrid.dart';
import 'package:tingting/utils/getCellSize.dart';
import 'package:tingting/utils/globalAlignment.dart';
import 'package:tingting/values/dimensions.dart';

class DiffBox extends StatelessWidget {
  DiffBox(this.alignment);

  final GlobalAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: textFieldPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = constraints.maxWidth;

              final cellSize = getCellSize(
                context,
                constraints,
                TextStyle(fontSize: textFieldFontSize),
                '你',
              );

              final nCharsPerLine = (boxWidth / cellSize).floor().toInt();

              final diffGrid = generateDiffGrid(alignment, nCharsPerLine);

              return StaggeredGridView.countBuilder(
                itemCount: diffGrid.length,
                crossAxisCount: nCharsPerLine,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => diffGrid[index],
                staggeredTileBuilder: (index) => StaggeredTile.count(
                    1, ((index / nCharsPerLine).floor() % 3) == 2 ? 0.5 : 1),
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}
