import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);
    var selectedCategory = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          var isSelected = selectedCategory == category;

          return _buildCategoryItem(context, ref, category, isSelected, isDark);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, WidgetRef ref,
      dynamic category, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category;
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: _buildCategoryDecoration(isSelected, isDark),
        alignment: Alignment.center,
        child: _buildCategoryText(category.text, isSelected, isDark),
      ),
    );
  }

  BoxDecoration _buildCategoryDecoration(bool isSelected, bool isDark) {
    final mainColor = isSelected
        ? isDark
            ? const Color(0xFFE0677A)
            : const Color(0xFFFF7B8E)
        : isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFFFE4E8);

    final borderColor = isSelected
        ? isDark
            ? const Color(0xFFE0677A)
            : const Color(0xFFFF7B8E)
        : isDark
            ? Colors.grey[700]!
            : const Color(0xFFFFD5DE);

    return BoxDecoration(
      color: mainColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: borderColor,
      ),
    );
  }

  Widget _buildCategoryText(String text, bool isSelected, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected
            ? Colors.white
            : isDark
                ? Colors.white70
                : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
