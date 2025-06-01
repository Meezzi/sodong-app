part of 'package:sodong_app/features/post/presentation/pages/create_post_page.dart';

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.createPostState,
    required this.createPostViewModel,
  });

  final CreatePostState createPostState;
  final CreatePostViewModel createPostViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFD5DE),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TownLifeCategory>(
          value: createPostState.category,
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_drop_down_circle_outlined,
            color: Color(0xFFFF7B8E),
          ),
          borderRadius: BorderRadius.circular(16),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          hint: const Text(
            '카테고리를 선택하세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          onChanged: (newCategory) {
            if (newCategory != null) {
              createPostViewModel.setCategory(newCategory);
            }
          },
          items: TownLifeCategory.values
              .where((category) => category != TownLifeCategory.all)
              .map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      size: 16,
                      color: const Color(0xFFFF7B8E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(TownLifeCategory category) {
    switch (category) {
      case TownLifeCategory.question:
        return Icons.help_outline;
      case TownLifeCategory.news:
        return Icons.campaign_outlined;
      case TownLifeCategory.help:
        return Icons.handshake_outlined;
      case TownLifeCategory.daily:
        return Icons.calendar_today_outlined;
      case TownLifeCategory.food:
        return Icons.restaurant_outlined;
      case TownLifeCategory.lost:
        return Icons.search_outlined;
      case TownLifeCategory.meeting:
        return Icons.groups_outlined;
      case TownLifeCategory.together:
        return Icons.people_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
