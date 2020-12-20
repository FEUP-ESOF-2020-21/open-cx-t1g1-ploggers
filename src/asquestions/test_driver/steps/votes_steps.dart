import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenTalkQuestions extends GivenWithWorld<FlutterWorld> {
  navigateToTalkQuestionsPage() async {
    final loginButtonFinder = find.byValueKey("LoginButton");

    await FlutterDriverUtils.tap(world.driver, loginButtonFinder);

    final emailFinder = find.byValueKey("LoginEmailField");
    final passwordFinder = find.byValueKey("LoginPasswordField");

    await FlutterDriverUtils.enterText(
        world.driver, emailFinder, "stanley.hannah@email.com");

    await FlutterDriverUtils.enterText(
        world.driver, passwordFinder, "12345678");

    final signInButtonFinder = find.byValueKey("SignInButton");

    await FlutterDriverUtils.tap(world.driver, signInButtonFinder);

    final talkButtonFinder = find.byValueKey("TalkButton0");

    await FlutterDriverUtils.tap(world.driver, talkButtonFinder);
  }

  @override
  Future<void> executeStep() async {
    await navigateToTalkQuestionsPage();

    final upvoteFinder =
        find.byValueKey("QuestionUpvoteButtonv9FRZAGU6KggJqyoX3S1");
    final downvoteFinder =
        find.byValueKey("QuestionDownvoteButtonv9FRZAGU6KggJqyoX3S1");

    await FlutterDriverUtils.isPresent(world.driver, upvoteFinder);
    await FlutterDriverUtils.isPresent(world.driver, downvoteFinder);
  }

  @override
  RegExp get pattern => RegExp(r"there are questions asked in the forum");
}

class WhenUserClicksUpvote extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final upvoteFinder = find.byValueKey("QuestionUpvoteButtonv9FRZAGU6KggJqyoX3S1");
    await FlutterDriverUtils.tap(world.driver, upvoteFinder);
  }

  @override
  RegExp get pattern => RegExp(
      r"the user clicks on the upvote button next to the questions");
}

class ThenUpvote extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final upvoteFinder = find.byValueKey("QuestionUpvoteButtonv9FRZAGU6KggJqyoX3S1");
    await FlutterDriverUtils.tap(world.driver, upvoteFinder);
  }

  @override
  RegExp get pattern =>
      RegExp(r"their score increases improving their visibility in the forum");
}

class WhenUserClicksDownvote extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final downvoteFinder = find.byValueKey("QuestionDownvoteButtonv9FRZAGU6KggJqyoX3S1");
    await FlutterDriverUtils.tap(world.driver, downvoteFinder);
  }

  @override
  RegExp get pattern => RegExp(r"the user clicks on the downvote button next to the questions");
}

class ThenDownvote extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final downvoteFinder = find.byValueKey("QuestionDownvoteButtonv9FRZAGU6KggJqyoX3S1");
    await FlutterDriverUtils.tap(world.driver, downvoteFinder);
  }

  @override
  RegExp get pattern =>
      RegExp(r"their score decreases lowering their visibility in the forum");
}
