Feature: Question Voting
    As an attendee, I want to be able to see and upvote/downvote questions so that the speaker knows which questions are most relevant for the audience.

    Scenario: Upvoting posted questions
        Given there are questions asked in the forum
        When I click on the "Upvote (Arrow up icon)" buttons next to the questions
        Then their score increases improving their visibility in the forum

    Scenario: Downvoting posted questions
        Given there are questions asked in the forum
        When I click on the "Downvote (Arrow down icon)" buttons next to the questions
        Then their score decreases lowering their visibility in the forum