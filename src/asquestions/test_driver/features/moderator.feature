Feature: Moderator Features
    Scenario: Highlight posted questions
        Given the user is a moderator that navigated to the forum
        When the user clicks on the highlight button next to the questions
        Then the question is put on top of the list, ignoring the upvote downvote system