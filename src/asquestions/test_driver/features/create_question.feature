Feature: Question Posting Features
    Scenario: Posting a question
        Given the user navigated to the talk questions forum
        When the user taps the Post a Question button
        And the user writes "Question Posting Features Test" 
        And the user selects slide number "1"
        And the user submits the question
        Then the question is added to the talk forum