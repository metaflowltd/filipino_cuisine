import 'dart:convert';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'cook.dart';
import 'deserializer.dart';
import 'ingredient.dart';
import 'preloader.dart';
import 'recipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(_) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.red,
          iconTheme: const IconThemeData(color: Colors.red),
          textTheme: const TextTheme(
            display2: TextStyle(
              fontFamily: 'ark',
              color: Colors.black,
            ),
            display3: TextStyle(
              fontFamily: 'ark',
              color: Colors.black,
            ),
            subtitle: TextStyle(
              fontFamily: 'opb',
            ),
            caption: TextStyle(
              fontFamily: 'opr',
            ),
          ),
        ),
        title: 'Filipino Cuisine',
        home: Home(),
      );
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  static const String _fetchDataUrl =
      'https://filipino-cuisine-app.firebaseio.com/data.json';
  static const String _assetsPath = 'assets';

  List<Recipe> _recipes;
  Recipe _activeRecipe;

  @override
  void initState() {
    super.initState();
    _fetchData().then((_) => _setActiveRecipe(0));
  }

  Future<void> _fetchData() async {
    final http.Response recipesData = await http.get(_fetchDataUrl);
    _recipes = Deserializer.deserializeRecipes(
      json.decode(recipesData.body).cast<Map<dynamic, dynamic>>(),
    ).toList();
  }

  void _setActiveRecipe(int index) =>
      setState(() => _activeRecipe = _recipes[index]);

  @override
  Widget build(BuildContext context) =>
      _recipes == null ? Preloader() : _buildApp(context);

  Widget _buildApp(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _buildBody(textTheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCook(context, _activeRecipe),
        child: const Icon(Icons.restaurant_menu),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody(TextTheme textTheme) => Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Expanded(
            flex: 5,
            child: _buildSwiper(),
          ),
          const SizedBox(height: 24),
          Text(_activeRecipe.name, style: textTheme.display3),
          const SizedBox(height: 10),
          Text(
            _activeRecipe.details,
            style: textTheme.subhead.copyWith(
              fontFamily: 'opb',
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            _activeRecipe.description,
            textAlign: TextAlign.center,
            style: textTheme.subhead.copyWith(
              fontFamily: 'opr',
              color: Colors.black,
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildIngredients(textTheme),
          ),
        ],
      );

  Widget _buildSwiper() => Swiper(
        viewportFraction: .85,
        scale: .9,
        itemCount: _recipes.length,
        itemBuilder: (_, int recipeIndex) =>
            _buildRecipePreview(_recipes[recipeIndex]),
        onIndexChanged: _setActiveRecipe,
      );
  Widget _buildRecipePreview(Recipe recipe) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Hero(
          tag: recipe.name,
          child: Image.asset(
            '$_assetsPath/${recipe.imageUrl}',
            fit: BoxFit.cover,
          ),
        ),
      );
  Widget _buildIngredients(TextTheme textTheme) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _activeRecipe.ingredients.length,
        itemBuilder: (_, int ingredientIndex) => _buildIngredient(
          _activeRecipe.ingredients[ingredientIndex],
          textTheme,
        ),
      );
  Widget _buildIngredient(Ingredient ingredient, TextTheme textTheme) => Row(
        children: <Widget>[
          const SizedBox(width: 10),
          Image.asset(
            '$_assetsPath/${ingredient.imageUrl}',
            fit: BoxFit.contain,
            height: 60,
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(ingredient.name, style: textTheme.subtitle),
              Text(ingredient.description, style: textTheme.caption),
            ],
          ),
          const SizedBox(width: 10),
        ],
      );
  void _navigateToCook(BuildContext context, Recipe recipe) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Cook(
            recipe.name,
            '$_assetsPath/${recipe.imageUrl}',
            recipe.steps,
          ),
        ),
      );
  Widget _buildBottomNavigationBar() => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _activeRecipe.isLiked ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: _toggleLike,
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: null,
            ),
          ],
        ),
      );
  void _toggleLike() =>
      setState(() => _activeRecipe.isLiked = !_activeRecipe.isLiked);
}
