import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenTalkQuestions extends GivenWithWorld<FlutterWorld> {
  navigateToTalkQuestionsPage() async {
    final loginButtonFinder = find.byValueKey("");
  }

  @override
  Future<void> executeStep() async {
    await navigateToTalkQuestionsPage();

    final upvoteFinder = find.byValueKey("LikeButton");
    final downvoteFinder = find.byValueKey("DislikeButton");

    await FlutterDriverUtils.isPresent(world.driver, upvoteFinder);
    await FlutterDriverUtils.isPresent(world.driver, downvoteFinder);
  }

  @override
  RegExp get pattern => RegExp(r"there are questions asked in the forum");
}


class ClickUpvoteButton extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    final newBubbleFinder = find.byValueKey(input1);
    await FlutterDriverUtils.tap(world.driver, newBubbleFinder);
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} button");
}

class ThenUpvote extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {}

  @override
  RegExp get pattern =>
      RegExp(r"their score increases improving their visibility in the forum");
}

class ThenDownvote extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {}

  @override
  RegExp get pattern =>
      RegExp(r"their score decreases lowering their visibility in the forum");
}

