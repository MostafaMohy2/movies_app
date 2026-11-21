class MovieEntity {
  final int id;
  final String image;
  final double rating;

  const MovieEntity({required this.id, required this.image, this.rating = 0.0});
}
