import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/town_life_view_model.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);
    var selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
    return GestureDetector(
      onTap: () {
        ref.read(selectedCategoryProvider.notifier).state = category;
      },
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: _buildCategoryDecoration(isSelected),
        alignment: Alignment.center,
        child: _buildCategoryText(category.text, isSelected),
      ),
    );
  }

  BoxDecoration _buildCategoryDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? const Color(0xffFF7B8E) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? const Color(0xffFF7B8E) : Colors.grey[300]!,
      ),
    );
  }

  Widget _buildCategoryText(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
