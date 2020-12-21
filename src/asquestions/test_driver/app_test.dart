import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/create_question_steps.dart';
import 'steps/votes_steps.dart';
import 'steps/moderator_steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/**.feature")]
    ..reporters = [
      ProgressReporter(),
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      GivenTalkQuestions(),
      WhenUserClicksUpvote(),
      ThenUpvote(),
      WhenUserClicksDownvote(),
      ThenDownvote(),

      GivenTalkQuestionsAsModerator(),
      WhenModeratorClicksMark(),
      ThenMark(),

      GivenTalkQuestionsForQuestionCreation(),
      WhenUserTapsAddQuestion(),
      AndUserWritesQuestion(),
      AndUserSelectsSlides(),
      AndUserSubmitsQuestions(),
      ThenQuestionIsAdded(),
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly
  return GherkinRunner().execute(config);
}
