# open-cx-t1g1-ploggers Development Report

Welcome to the documentation pages of the AsQuestions of **openCX**!

* Business modeling 
  * [Product Vision](#Product-Vision)
  * [Elevator Pitch](#Elevator-Pitch)
* Requirements
  * [Use Case Diagram](#Use-case-diagram)
  * [User stories](#User-stories)
  * [Domain model](#Domain-model)
* Architecture and Design
  * [Logical architecture](#Logical-architecture)
  * [Physical architecture](#Physical-architecture)
  * [Prototype](#Prototype)
* [Implementation](#Implementation)
* [Test](#Test)
* [Configuration and change management](#Configuration-and-change-management)
* [Project management](#Project-management)

Please contact us!

Thank you!

Caio Nogueira

Diogo Almeida

João Pinto

Miguel Silva

Pedro Queirós

Telmo Botelho

---

## Product Vision

AsQuestions aims to encourage and simplify host-attendee interaction during conferences by providing an easy-to-use interface for posting, rating, and answering questions.

---
## Elevator Pitch



---
## Requirements

### Use Case Diagram

![Use case diagram](./img/use_cases.png)

---

### User Stories

#### **Story #1**

As an attendee, I want to post questions so that the host or other attendees can answer them.

_User interface mockups_

![User story #1 mockup1](./img/mockup1.png)
![User story #1 mockup2](./img/mockup2.png)



_Acceptance Tests_

```gherkin
Scenario: Posting a question
	Given there are 4 questions asked in the forum
	When I tap the "Post a Question (+ icon)" button
	And I write and submit a question
	Then there are 5 questions asked in the forum.
```

_Value/Effort_

Value: Must have

Effort: XL

---
#### **Story #2**

As an attendee, I want to be able to mention a specific part of the presentation with my question (like a slide) to help the host better understand it.

_User interface mockups_

![User story #2 mockup3](./img/mockup3.png)

_Acceptance Tests_

```gherkin
Scenario: Mentioning/Tagging a part of the presentation with my question
	Given that I'm posting a question in the forum
	When I click on the "Add a Slide (Clip icon)" button
	Then the app allows me to refer a slide related to my question
```
_Value/Effort_

Value: Should have

Effort: M

---
#### **Story #3**

As an attendee, I want to answer questions so that I can help the other attendees.

_User interface mockups_

![User story #3 mockup4](./img/mockup4.png)

_Acceptance Tests_
```gherkin
Scenario: Answering other attendees' questions
	Given there are 4 questions asked in the forum,
	When I click on one of them
	Then the app shows me the question and its comment thread
	When I tap the Textbox
	Then the system allows me to write an answer 
	When I tap the "Submit Answer" button
	Then the system posts the answer to the thread
```
_Value/Effort_

Value: Must have

Effort: L

---
#### **Story #4**

As an attendee, I want to be able to upvote/downvote questions so that the host knows which questions are most relevant for the audience.

_User interface mockups_

![User story #4 mockup1](./img/mockup1.png)

_Acceptance Tests_
```gherkin
Scenario: Upvoting/Downvoting posted questions
	Given there are 3 questions asked in the forum
	When I click on the "Upvote" or "Downvote" buttons next to the questions
	Then their score increases or decreases respectively affecting their visibility in the forum
```
_Value/Effort_

Value: Must Have

Effort: M

---
#### **Story #5**

As a host, I want to answer my audience’s questions so that they can leave the session clarified and informed.

_User interface mockups_

![User story #5 mockup5](./img/mockup5.png)

_Acceptance Tests_
```gherkin
Scenario: Answering questions from the audience
	Given I'm logged in as a host and there are 3 questions asked in the forum 
	When I click on one of them
	Then the app shows me the question and its comment thread
	When I tap the Textbox
	Then the system allows me to write an answer
    When I tap the "Submit Answer" button
	Then the system posts the answer to the thread and fixes it at the top, marking it as the host's response
```
_Value/Effort_

Value: Must Have

Effort: XL

---
#### **Story #6**

As a host, I want to be able to create a forum for my audience to place their questions about the presentation.

_User interface mockups_

![User story #6 mockup6](./img/mockup6.png)
![User story #6 mockup7](./img/mockup7.png)

_Acceptance Tests_
```gherkin
Scenario: Creating a forum for the audience's questions
	Given I’m logged-in as a host
	Then the app shows me a menu of options
	When I click the ‘Create Conference Room’ button
	Then the app shows me a form to fill with information about the conference
	When I click the 'Create' button
	Then the app creates the empty question forum and takes me to it
```
_Value/Effort_

Value: Must Have

Effort: XL

---
#### **Story #7**

As a moderator, I want to be able to control what questions are passed to the host so that the most relevant are answered.

_User interface mockups_

![User story #7 mockup8](./img/mockup8.png)

_Acceptance Tests_
```gherkin
Scenario: Controlling which questions are passed to the host
	Given I’m logged-in as a moderator and there are 4 questions asked in the forum 
	When I click on "Send question to host (Star icon)"
	Then the system puts the question on top of the list for the host, ignoring the upvote/downvote system
	When I click on "Delete Question (Trash bin icon)"
	Then the app deletes that question from the forum
```
_Value/Effort_

Value: Should Have

Effort: M

### Domain model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module.

------

## Architecture and Design

The architecture of a software system encompasses the set of key decisions about its overall organization.

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them.

In this section you should start by briefly describing the overall components of the project and their interrelations. You should also describe how you solved typical problems you may have encountered, pointing to well-known architectural and design patterns, if applicable.

### Logical architecture

The purpose of this subsection is to document the high-level logical structure of the code, using a UML diagram with logical packages, without the worry of allocating to components, processes or machines.

It can be beneficial to present the system both in a horizontal or vertical decomposition:

- horizontal decomposition may define layers and implementation concepts, such as the user interface, business logic and concepts;
- vertical decomposition can define a hierarchy of subsystems that cover all layers of implementation.

### Physical architecture

The goal of this subsection is to document the high-level physical structure of the software system (machines, connections, software components installed, and their dependencies) using UML deployment diagrams or component diagrams (separate or integrated), showing the physical structure of the system.

It should describe also the technologies considered and justify the selections made. Examples of technologies relevant for openCX are, for example, frameworks for mobile applications (Flutter vs ReactNative vs ...), languages to program with microbit, and communication with things (beacons, sensors, etc.).

### Prototype

To help on validating all the architectural, design and technological decisions made, we usually implement a vertical prototype, a thin vertical slice of the system.

In this subsection please describe in more detail which, and how, user(s) story(ies) were implemented.

------

## Implementation

Regular product increments are a good practice of product management.

While not necessary, sometimes it might be useful to explain a few aspects of the code that have the greatest potential to confuse software engineers about how it works. Since the code should speak by itself, try to keep this section as short and simple as possible.

Use cross-links to the code repository and only embed real fragments of code when strictly needed, since they tend to become outdated very soon.

------

## Test

There are several ways of documenting testing activities, and quality assurance in general, being the most common: a strategy, a plan, test case specifications, and test checklists.

In this section it is only expected to include the following:

- test plan describing the list of features to be tested and the testing methods and tools;
- test case specifications to verify the functionalities, using unit tests and acceptance tests.

A good practice is to simplify this, avoiding repetitions, and automating the testing actions as much as possible.

------

## Configuration and change management

Configuration and change management are key activities to control change to, and maintain the integrity of, a project’s artifacts (code, models, documents).

For the purpose of ESOF, we will use a very simple approach, just to manage feature requests, bug fixes, and improvements, using GitHub issues and following the [GitHub flow](https://guides.github.com/introduction/flow/).

------

## Project management

Software project management is an art and science of planning and leading software projects, in which software projects are planned, implemented, monitored and controlled.

In the context of ESOF, we expect that each team adopts a project management tool capable of registering tasks, assign tasks to people, add estimations to tasks, monitor tasks progress, and therefore being able to track their projects.

Example of tools to do this are:

- [Trello.com](https://trello.com/)
- [Github Projects](https://github.com/features/project-management/com)
- [Pivotal Tracker](https://www.pivotaltracker.com/)
- [Jira](https://www.atlassian.com/software/jira)

We recommend to use the simplest tool that can possibly work for the team.

------

## Evolution - contributions to open-cx

Describe your contribution to open-cx (iteration 5), linking to the appropriate pull requests, issues, documentation.

---
