import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/bloc/events.dart';
import 'package:task_management_app/bloc/states.dart';

// class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
//   ToDoBloc() : super(InitialToDoState());

//   Stream<ToDoState> mapEventToState(ToDoEvent event) async* {
//     if (event is AddTaskEvent) {
//       yield* _mapAddTaskEventToState(event);
//     }
//   }

//   Stream<ToDoState> _mapAddTaskEventToState(AddTaskEvent event) async* {
//     // Add your logic to handle the AddTaskEvent here
//     // For example, you can add the task to your list of tasks
//     yield UpdatedToDoState(tasks: [], tasksDescription: []); // Emit a new state after handling the event
//   }
// }

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoBloc() : super(InitialState());

  @override
  Stream<ToDoState> mapEventToState(ToDoEvent event) async* {
    if (event is AddTaskEvent) {
      yield TaskAddedState(event.title, event.description, event.dateTime);
    }
  }
}
