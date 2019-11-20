import 'ingredient.dart';
import 'step.dart';

class Recipe {
  Recipe({
    this.name,
    this.imageUrl,
    this.details,
    this.description,
    this.ingredients,
    this.steps,
  });

  final String name;
  final String imageUrl;
  final String details;
  final String description;
  final List<Ingredient> ingredients;
  final List<Step> steps;

  bool isLiked = false;
}
