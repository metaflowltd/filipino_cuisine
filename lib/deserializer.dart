import 'ingredient.dart';
import 'recipe.dart';
import 'step.dart';

class Deserializer {
  static Iterable<Recipe> deserializeRecipes(
    List<Map<dynamic, dynamic>> recipesData,
  ) =>
      recipesData.map(_deserializeRecipe);
  static Recipe _deserializeRecipe(Map<dynamic, dynamic> recipeData) => Recipe(
        name: recipeData['fn'],
        imageUrl: recipeData['pf'],
        details: recipeData['cn'],
        description: recipeData['dc'],
        ingredients: _deserializeIngredients(
          recipeData['ig'].cast<Map<dynamic, dynamic>>(),
        ).toList(),
        steps: _deserializeSteps(recipeData['in'].cast<String>()).toList(),
      );
  static Iterable<Ingredient> _deserializeIngredients(
    List<Map<dynamic, dynamic>> ingredientsData,
  ) =>
      ingredientsData.map(_deserializeIngredient);
  static Ingredient _deserializeIngredient(
    Map<dynamic, dynamic> ingredientData,
  ) =>
      Ingredient(
        name: ingredientData['n'],
        description: ingredientData['c'],
        imageUrl: ingredientData['p'],
      );
  static Iterable<Step> _deserializeSteps(List<String> stepsData) =>
      stepsData.map(_deserializeStep);
  static Step _deserializeStep(String stepText) => Step(stepText);
}
