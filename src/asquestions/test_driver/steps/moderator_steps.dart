import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenTalkQuestionsAsModerator extends GivenWithWorld<FlutterWorld> {
  navigateToTalkQuestionsPageAsModerator() async {
    final loginButtonFinder = find.byValueKey("LoginButton");

    await FlutterDriverUtils.tap(world.driver, loginButtonFinder);

    final emailFinder = find.byValueKey("LoginEmailField");
    final passwordFinder = find.byValueKey("LoginPasswordField");

    await FlutterDriverUtils.enterText(
        world.driver, emailFinder, "gardner.solomon@email.com");

    await FlutterDriverUtils.enterText(
        world.driver, passwordFinder, "12345678");

    final signInButtonFinder = find.byValueKey("SignInButton");

    await FlutterDriverUtils.tap(world.driver, signInButtonFinder);

    final talkButtonFinder = find.byValueKey("TalkButton7iKsTbzcoCaYhARsYPO2");

    await FlutterDriverUtils.tap(world.driver, talkButtonFinder);
  }

  @override
  Future<void> executeStep() async {
    await navigateToTalkQuestionsPageAsModerator();

    final markFinder = find.byValueKey("QuestionMarkButtonA9og5Ds7m5AmRrLc0sMC");

    await FlutterDriverUtils.isPresent(world.driver, markFinder);
  }

  @override
  RegExp get pattern => RegExp(r"the user is a moderator that navigated to the forum");
}

class WhenModeratorClicksMark extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final markFinder = find.byValueKey("QuestionMarkButtonA9og5Ds7m5AmRrLc0sMC");
    await FlutterDriverUtils.tap(world.driver, markFinder);
  }

  @override
  RegExp get pattern => RegExp(r"the user clicks on the highlight button next to the questions");
}

class ThenMark extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final markFinder = find.byValueKey("QuestionMarkButtonA9og5Ds7m5AmRrLc0sMC");
    await FlutterDriverUtils.tap(world.driver, markFinder);
  }

  @override
  RegExp get pattern =>
      RegExp(r"the question is put on top of the list, ignoring the upvote downvote system");
}
