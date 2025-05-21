part of 'package:sodong_app/features/create_post/presentation/pages/create_post_page.dart';

class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(createPostViewModelProvider);
    final notifier = ref.read(createPostViewModelProvider.notifier);

    return DropdownButton<TownLifeCategory>(
      value: viewModel.category,
      isExpanded: true,
      onChanged: (newCategory) {
        if (newCategory != null) {
          notifier.setCategory(newCategory);
        }
      },
      items: TownLifeCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.text),
        );
      }).toList(),
    );
  }
}
