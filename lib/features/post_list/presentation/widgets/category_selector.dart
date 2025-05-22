import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sodong_app/features/post_list/presentation/view_models/town_life_view_model.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);
    var selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          var isSelected = selectedCategory == category;

          return _buildCategoryItem(context, ref, category, isSelected);
        },
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, WidgetRef ref, dynamic category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: const Color(0xFFFFE4E8),
            highlightColor: const Color(0xFFFFE4E8).withOpacity(0.3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: _buildCategoryDecoration(isSelected),
              alignment: Alignment.center,
              child: _buildCategoryText(category.text, isSelected),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCategoryDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? const Color(0xFFFF7B8E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? const Color(0xFFFF7B8E) : const Color(0xFFFFD5DE),
        width: 1.5,
      ),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: const Color(0xFFFF7B8E).withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  Widget _buildCategoryText(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFFFF7B8E),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 14,
      ),
    );
  }
}
