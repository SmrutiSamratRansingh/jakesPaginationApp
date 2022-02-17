import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jakes_git_app/datamodel/jake_model.dart';
import 'package:jakes_git_app/repository/api_client.dart';

import 'home_screen_events.dart';
import 'home_screen_states.dart';

class JakeBloc extends Bloc<JakeEvent, JakeState> {
  // late final UserRepository userRepository;
  ApiClient apiClient = ApiClient();
  var pageNo = 1;
  List<JakeData> jakeList = [];
  JakeBloc() : super(OnLoading());
  // EatingHabit? eatingHabit;
  // DrinkingHabit? drinkingHabit;
  // SmokingHabit? smokingHabit;

  @override
  Stream<JakeState> mapEventToState(JakeEvent event) async* {
    yield OnLoading();
    if (event is GetDataEvent) {
      var response = await this.apiClient.getJakeData(this.pageNo);
      if (response.status == 'SUCCESS') {
        for (int i = 0; i < response.list.length; i++) {
          this.jakeList.add(response.list[i]);
        }

        pageNo = pageNo + 1;
        yield OnGotJakeDataState();
      } else {
        yield OnError(response.message);
      }
    }
  }
}
