import 'package:flutter/material.dart' hide Step;
import 'step.dart';

class Cook extends StatefulWidget {
  const Cook(this.name, this.imageUrl, this.steps);

  final String name;
  final String imageUrl;
  final List<Step> steps;

  @override
  CookState createState() => CookState();
}

class CookState extends State<Cook> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('INSTRUCTIONS'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            _buildRecipePreview(
              widget.name,
              widget.imageUrl,
              Theme.of(context).textTheme,
            ),
            const SizedBox(height: 30),
            Expanded(child: _buildSteps(widget.steps)),
          ],
        ),
      );
  Widget _buildRecipePreview(
    String name,
    String imageUrl,
    TextTheme textTheme,
  ) =>
      Container(
        padding: const EdgeInsets.only(left: 20),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Hero(
              tag: name,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
          title: Text(
            name,
            style: textTheme.display2,
          ),
        ),
      );
  Widget _buildSteps(List<Step> steps) => ListView.builder(
        itemCount: steps.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (_, int stepIndex) => _buildStep(steps[stepIndex]),
      );
  Widget _buildStep(Step step) => ListTile(
        title: Text(step.text),
        trailing: Checkbox(
          value: step.isFinished,
          onChanged: (bool isFinished) => _setStepFinished(
            step,
            isFinished,
          ),
        ),
      );
  void _setStepFinished(Step step, bool isFinished) =>
      setState(() => step.isFinished = isFinished);
}
