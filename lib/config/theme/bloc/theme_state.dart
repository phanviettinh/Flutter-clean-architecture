import 'package:equatable/equatable.dart';

  class ThemeState extends Equatable{
  final bool isDarkMode;


  const ThemeState({required this.isDarkMode});
  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
  @override
  // TODO: implement props
  List<Object?> get props => [isDarkMode];
}


