import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../config/category_config.dart';
import 'category_image_item.dart';

/// List of Category Items
class CategoryImages extends StatelessWidget {
  final CategoryConfig config;

  const CategoryImages({required this.config, Key? key}) : super(key: key);

  List<Widget> listItem({maxWidth}) {
    var items = <Widget>[];
    var sizeWidth;
    var sizeHeight;
    var itemSize = config.commonItemConfig.itemSize;

    if (itemSize != null) {
      sizeWidth = itemSize.width;
      sizeHeight = itemSize.height;
    } else {
      sizeWidth = maxWidth / 3;
    }
    for (var item in config.items) {
      items.add(CategoryImageItem(
          config: item,
          width: sizeWidth,
          height: sizeHeight,
          commonConfig: config.commonItemConfig));
    }
    return items;
  }

  Widget rendorColumns(int column, {double? maxItemWidth}) {
    var items = config.items;
    var itemSize = config.commonItemConfig.itemSize;
    var length = items.length ~/ column;
    if (length * column < items.length) length++;

    return Container(
        height: 600,
        margin: EdgeInsets.only(top: 15),
        child: GridView.custom(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverWovenGridDelegate.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            pattern: [
              WovenGridTile(.9),
              // WovenGridTile(
              //   5 / 7,
              //   crossAxisRatio: 0.9,
              //   alignment: AlignmentDirectional.centerEnd,
              // ),
              WovenGridTile(.9),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(childCount: items.length,
              (context, index) {
            // var index = indexRow * column + indexColumn;
            if (index >= items.length) return const SizedBox();
            var item = items[index];

            return CategoryImageItem(
              config: item,
              width: itemSize?.width ?? maxItemWidth,
              height: itemSize?.height,
              commonConfig: config.commonItemConfig,
              isDoubleIndex: index.isOdd,
            );
          }),
        ));

    // return Column(
    //   children: List.generate(
    //     length,
    //     (indexRow) => Row(
    //       children: List.generate(column, (indexColumn) {
    //         return Expanded(child: Builder(
    //           builder: (context) {
    //             var index = indexRow * column + indexColumn;
    //             if (index >= items.length) return const SizedBox();
    //             var item = items[index];
    //             return CategoryImageItem(
    //               config: item,
    //               width: itemSize?.width ?? maxItemWidth,
    //               height: itemSize?.height,
    //               commonConfig: config.commonItemConfig,
    //             );
    //           },
    //         ));
    //       }),
    //     ),
    //   ),
    // );

    // return Column(
    //   children: List.generate(
    //     length,
    //     (indexRow) => Row(
    //       children: List.generate(column, (indexColumn) {
    //         return Expanded(child: Builder(
    //           builder: (context) {
    //             var index = indexRow * column + indexColumn;
    //             if (index >= items.length) return const SizedBox();
    //             var item = items[index];
    //             return CategoryImageItem(
    //               config: item,
    //               width: itemSize?.width ?? maxItemWidth,
    //               height: itemSize?.height,
    //               commonConfig: config.commonItemConfig,
    //             );
    //           },
    //         ));
    //       }),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var itemSize = config.commonItemConfig.itemSize;
    var sizeHeight = itemSize?.height;

    return Container(
      margin: EdgeInsets.only(
        left: config.marginLeft,
        right: config.marginRight,
        top: config.marginTop,
        bottom: config.marginBottom,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var maxWidth =
              constraints.maxWidth - config.marginLeft - config.marginRight;
          final width = maxWidth / 10;
          final heightList = width + 22;

          if (config.wrap) {
            if (config.columns != null) {
              final itemWidth =
                  constraints.maxWidth / config.columns!.toDouble();
              return rendorColumns(config.columns!, maxItemWidth: itemWidth);
            }
            return Wrap(
              alignment: WrapAlignment.center,
              children: listItem(maxWidth: maxWidth),
            );
          }

          return SizedBox(
            height: sizeHeight ?? heightList + 80,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: listItem(maxWidth: maxWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}
