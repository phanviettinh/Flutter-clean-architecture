import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ring/config/theme/bloc/theme_event.dart';
import 'package:note_ring/config/theme/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent,ThemeState>{
  ThemeBloc() : super(ThemeState(isDarkMode: false)){
    on<ToggleThemeEvent>(_onToggleTheme);
  }
  _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit ){
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}