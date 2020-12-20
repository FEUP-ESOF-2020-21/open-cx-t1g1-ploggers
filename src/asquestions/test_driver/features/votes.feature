Feature: Question Voting
    Scenario: Upvoting posted questions
        Given there are questions asked in the forum
        When the user clicks on the upvote button next to the questions
        Then their score increases improving their visibility in the forum

    Scenario: Downvoting posted questions
        Given there are questions asked in the forum
        When the user clicks on the downvote button next to the questions
        Then their score decreases lowering their visibility in the forum