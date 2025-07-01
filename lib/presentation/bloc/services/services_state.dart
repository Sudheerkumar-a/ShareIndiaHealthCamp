part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {}

class Init extends ServicesState {
  @override
  List<Object?> get props => [];
}

class ServicesStateLoading extends ServicesState {
  @override
  List<Object?> get props => [];
}

class ServicesStateSuccess extends ServicesState {
  final ApiEntity<BaseEntity> responseEntity;

  ServicesStateSuccess({required this.responseEntity});
  @override
  List<Object?> get props => [responseEntity];
}

class ServicesStateApiError extends ServicesState {
  final String message;

  ServicesStateApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
