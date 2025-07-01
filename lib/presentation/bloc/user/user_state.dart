part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class Init extends UserState {
  @override
  List<Object?> get props => [];
}

class OnLoginLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class OnApiResponse extends UserState {
  final ApiEntity<BaseEntity> responseEntity;

  OnApiResponse({required this.responseEntity});
  @override
  List<Object?> get props => [responseEntity];
}

class OnLoginApiError extends UserState {
  final String message;

  OnLoginApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
