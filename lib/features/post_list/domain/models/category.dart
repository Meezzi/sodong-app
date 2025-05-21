// 동네생활 카테고리 enum
enum TownLifeCategory {
  all('all', '전체'),
  question('question', '우리동네질문'),
  news('news', '동네소식'),
  help('help', '해주세요'),
  daily('daily', '일상'),
  food('food', '동네맛집'),
  lost('lost', '분실/실종'),
  meeting('meeting', '동네모임'),
  together('together', '같이해요');

  final String id;
  final String text;

  const TownLifeCategory(this.id, this.text);

  // id로 카테고리 찾기
  static TownLifeCategory fromId(String id) {
    return TownLifeCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => TownLifeCategory.all,
    );
  }
}

// 모든 카테고리 목록 반환
List<TownLifeCategory> get allCategories => TownLifeCategory.values;
