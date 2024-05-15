// abstract class ToDoStates {}

// class InitialState extends ToDoStates {}

// class TaskCreateState extends ToDoStates {}

// class TaskCreatedState extends ToDoStates {}

// class TasksLoadedState extends ToDoStates {
//   TasksLoadedState(List<String> tasks);

//   get tasks => "";

//   get tasksDescription => "";
// }
abstract class ToDoState {}

class InitialState extends ToDoState {}

class TaskAddedState extends ToDoState {
  final String title;
  final String description;
  final DateTime dateTime;

  TaskAddedState(this.title, this.description, this.dateTime);
}
