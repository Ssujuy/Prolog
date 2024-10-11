# Prolog Projects

## Table of Contents
1. [Pancakes Project](#pancakes-project)
2. [Skyscraper Puzzle Project](#skyscraper-puzzle-solver-project)
3. [MaxSAT Project](#maxsat-project)
4. [Crossword Solver Project](#crossword-solver-project)
5. [Search Problem project](#search-problem-project)
6. [Assignment Project](#assignment-project)
7. [Activity Assignment CSP project](#activity-assignment-csp-project)


## Pancakes project (pancakes.pl)

- The process begins by attempting to sort a list of pancakes, where each pancake can be flipped from a certain position in the stack to achieve the sorted order.
- The algorithm searches for a sequence of flips that will eventually sort the list in ascending order, starting with a given state of unsorted pancakes.
- At each step, a flip is applied to reverse part of the list from a chosen position, and the resulting new state is checked to see if it has already been visited or if it is the final sorted state.
- If the current list is not sorted, the process continues recursively, trying different flip positions, while keeping track of the sequence of operations and intermediate states.
- The algorithm stops when the list is fully sorted, at which point the sequence of flip operations is returned as the solution. If a solution is not found with the current approach, it expands the search by increasing the allowed number of flips.

## Skyscraper Puzzle Solver project (skyscr.pl)

- The program solves the "Skyscraper" puzzle by enforcing constraints based on the puzzle's rules. The grid is populated with numbers representing building heights, and constraints are placed on how many skyscrapers are visible from each side of the grid (top, bottom, left, right).
- The main function initializes the puzzle with the provided constraints (maximum height, visible skyscrapers from each side, etc.). The solution is represented as a 2D grid where each element is constrained to represent the height of a building (from 1 to the grid's maximum height).
- For each row and column, the code ensures that no two buildings have the same height, using constraints to enforce that the numbers in the grid are all different for each row and column.
- The visibility constraints are applied based on how many skyscrapers are visible from each side (left, right, top, and bottom). The number of visible skyscrapers depends on how many taller buildings appear as you look across a row or column.
- The program checks for visibility constraints by iterating over each row or column, creating a list of visible skyscrapers, and constraining that list to ensure the correct number of skyscrapers are visible from each perspective.
- The search for a solution is performed using the `search/5` function, which applies the constraints and attempts to find valid values for the grid that satisfy all conditions.
- Helper functions are used to manage specific tasks, such as finding elements in the grid, reversing lists, enforcing constraints on skyscrapers visible from different sides, and ensuring that rows and columns contain distinct values.

## MaxSAT project (maxsat.pl)

- The code defines a MaxSAT problem, where the goal is to maximize the number of satisfied clauses in a Boolean formula consisting of several variables and clauses.
- It begins by generating a random Boolean formula with a given number of variables, clauses, and density, ensuring that each variable in the formula can take values of 0 or 1.
- The algorithm assigns values to the variables and checks whether each clause in the formula evaluates to true. It calculates the cost (number of satisfied clauses) as it proceeds.
- The search process is guided by a branch-and-bound method, which looks for the solution that maximizes the number of satisfied clauses, using restarts and pruning to optimize the search.
- Finally, the program returns the best solution found, which is the variable assignment that satisfies the maximum number of clauses.

## Crossword Solver project (crossword.pl)

- The code is designed to solve a crossword puzzle by filling in empty spots with letters, ensuring that blacked-out cells are accounted for and respected.
- The crossword grid is represented as a 2D list, with predefined black spots, and the solution involves filling the grid with words that fit the available spaces.
- The process starts by finding all the empty spots in the grid, where words can be placed, and then converting the words into their ASCII representations to facilitate manipulation and matching.
- The algorithm recursively fills the empty spaces with words, ensuring that they fit the dimensions of the grid and match the structure (length) of the available spaces.
- Once the crossword is filled, the solution is printed by converting the ASCII values back into letters and displaying the grid in a readable format, where black spots are marked and empty spots are filled with letters.
- The system uses helper functions to handle tasks like splitting words into their corresponding positions, checking constraints (such as fitting a word in a row or column), and managing black cells in the grid.
- The entire process is driven by sorting the words and spaces based on length and then matching words to fit available spaces, ensuring that the crossword is correctly filled.

## Search Problem project (numpart.pl)

- The code is designed to solve a problem where two lists of equal length are generated, each containing unique elements from the range 1 to N. The code ensures that both lists are distinct and satisfy certain conditions regarding their sums and the sum of their squares.
- It begins by checking if `N` (the total number of elements) is even. This ensures that the two lists can have equal length, which is set as `N/2`.
- Both lists (`L1` and `L2`) are constrained to contain integers between 1 and `N`. The elements in each list are unique, and no element appears in both lists (i.e., they are disjoint).
- The sum and square sum of both lists are constrained. The sum of elements in both lists is calculated using the formula for the sum of the first N numbers, and similarly, the sum of squares is constrained.
- The search algorithm (`search/5`) is used to find a solution where both lists meet the constraints. It searches for values that satisfy the conditions imposed on the sums and square sums for both lists.
- Helper functions like `find_sum/3` and `find_square_sum/3` are used to calculate the sum and square sum of the elements in each list, respectively.
- Additional functions ensure that the elements of both lists are unique, disjoint, and properly constrained to ensure a valid solution.


## Assignment project (assignment.pl)

- The code solves a constraint satisfaction problem (CSP) where activities are assigned to people over time, ensuring that total time allocated does not exceed a specified maximum (`MT`). The assignment involves creating a solution for the `ASP` (Activity Sequence Plan) and the `ASA` (Activity Sequence Assignment).
- The `assignment/4` predicate takes in the number of people (`NP`), the maximum allowed time (`MT`), and returns two solutions: `ASP` (the sequence of activities for each person) and `ASA` (the activity-person assignment).
- The solution begins by sorting all activities based on their start times, which helps determine the sequence in which activities should be assigned.
- The `find_ASP/5` predicate recursively finds a sequence of activities for each person, ensuring that the total time for each person does not exceed `MT`. This is done by constructing the `ASP` list, which records the activities assigned to each person and the total time spent.
- Activities are assigned to people in such a way that there is no overlap in time, and at least one time unit separates consecutive activities for a given person. If a valid sequence is found, it is appended to the `ASP` list.
- The `find_ASA/3` function uses the `ASP` solution to construct the `ASA` list, which associates each activity with the person assigned to it. It ensures that each activity is mapped correctly to the person in the `ASP`.
- Helper functions like `sequence/6` are used to recursively assign activities, ensuring that the total time for each person is below the limit and that activities are spaced appropriately in time.
- The `remove_sublist/3` and `remove/3` functions help manage the list of remaining activities as each person is assigned their sequence of activities.
- Overall, the code ensures that activities are allocated efficiently among people without exceeding the time constraints, producing both the `ASP` and `ASA` solutions.


## Activity Assignment CSP project (assignment_csp.pl)

- The code solves a Constraint Satisfaction Problem (CSP) where the goal is to assign a set of activities to different people, ensuring that no two activities assigned to the same person overlap in time.
- It starts by identifying all the activities from the list and assigning each activity a variable representing which person (out of `NP` people) will handle that activity.
- Each person is assigned activities such that no two activities they handle overlap. This is achieved by sorting the activities by start times and using constraints to ensure that activities assigned to the same person do not conflict.
- A list of couples of activities is created, where each couple consists of two activities that overlap in time. Constraints are placed so that each activity pair in this list is assigned to different people, ensuring no time conflicts.
- The `search` function is used to assign values to the variables representing people, aiming to find an assignment that satisfies all the constraints.
- Helper functions are used to manage specific tasks, such as sorting the activities based on their start times, finding pairs of activities that overlap, and ensuring that no conflicting activities are assigned to the same person.

