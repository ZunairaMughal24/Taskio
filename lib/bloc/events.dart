// abstract class ToDoEvents {}

// class AddTaskEvent extends ToDoEvents {
//   AddTaskEvent(String task);

//   get task => null;
// }

// class TaskAddedEvent extends ToDoEvents {}

// Define your events

abstract class ToDoEvent {}

class AddTaskEvent extends ToDoEvent {
  final String title;
  final String description;
  final DateTime dateTime;

  AddTaskEvent(this.title, this.description, this.dateTime);
}
