import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class GivenTalkQuestionsForQuestionCreation extends GivenWithWorld<FlutterWorld> {
  navigateToTalkQuestionsPageAsModerator() async {
    final loginButtonFinder = find.byValueKey("LoginButton");

    await FlutterDriverUtils.tap(world.driver, loginButtonFinder);

    final emailFinder = find.byValueKey("LoginEmailField");
    final passwordFinder = find.byValueKey("LoginPasswordField");

    await FlutterDriverUtils.enterText(
        world.driver, emailFinder, "matthams.carlos@email.com");

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

    final markFinder = find.byValueKey("QuestionMarkButtonv9FRZAGU6KggJqyoX3S1");

    await FlutterDriverUtils.isPresent(world.driver, markFinder);
  }

  @override
  RegExp get pattern =>
      RegExp(r"the user navigated to the talk questions forum");
}

class WhenUserTapsAddQuestion extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final addQuestionFinder = find.byValueKey("QuestionAddButton");
    await FlutterDriverUtils.tap(world.driver, addQuestionFinder);
  }

  @override
  RegExp get pattern => RegExp(r"the user taps the Post a Question button");
}

class AndUserWritesQuestion extends And1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    final questionFieldFinder = find.byValueKey("QuestionField");
    await FlutterDriverUtils.enterText(
        world.driver, questionFieldFinder, input1);
  }

  @override
  RegExp get pattern => RegExp(r"the user writes {string}");
}

class AndUserSelectsSlides extends And1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    final slideFinder = find.byValueKey("AnnexSlideButton" + input1);
    await FlutterDriverUtils.tap(world.driver, slideFinder);
  }

  @override
  RegExp get pattern =>
      RegExp(r"the user selects slide number {string}");
}

class AndUserSubmitsQuestions extends AndWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final submitFinder = find.byValueKey("SubmitButton");
    await FlutterDriverUtils.tap(world.driver, submitFinder);
  }

  @override
  RegExp get pattern => RegExp(r"the user submits the question");
}

class ThenQuestionIsAdded extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
  }

  @override
  RegExp get pattern =>
      RegExp(r"the question is added to the talk forum");
}
