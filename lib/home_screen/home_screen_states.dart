import 'base_event_state.dart';

class JakeState extends BaseEventState {}

class OnGotJakeDataState extends JakeState {
  OnGotJakeDataState();
}

class OnLoading extends JakeState {}

class OnError extends JakeState {
  final String message;

  OnError(this.message);
}
