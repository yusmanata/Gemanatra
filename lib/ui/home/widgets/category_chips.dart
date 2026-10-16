import 'package:flutter/material.dart';

import '../../core/themes/dimens.dart';

/// Komponen pemilih kategori berita horizontal.
/// Didesain dengan touch target yang nyaman dan semantik status terpilih.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dimens = Dimens.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text('Kategori Berita', style: textTheme.titleMedium),
        ),
        SizedBox(height: dimens.spacingSmall + 2.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(categories.length, (index) {
              final isSelected = selectedIndex == index;
              final categoryName = categories[index];

              return Padding(
                padding: EdgeInsets.only(right: dimens.spacingSmall),
                child: Semantics(
                  selected: isSelected,
                  label:
                      'Kategori $categoryName, ${isSelected ? 'terpilih' : 'ketuk dua kali untuk memilih'}',
                  button: true,
                  child: ChoiceChip(
                    selected: isSelected,
                    onSelected: (_) => onSelected(index),
                    label: Text(categoryName),
                    avatar: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16.0,
                            color: Colors.black,
                          )
                        : null,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
