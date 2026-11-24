import 'package:equatable/equatable.dart';
import '../../models/household_model.dart';

abstract class HouseholdsEvent extends Equatable {
  const HouseholdsEvent();

  @override
  List<Object?> get props => [];
}

class HouseholdsFetchRequested extends HouseholdsEvent {
  const HouseholdsFetchRequested();
}

class HouseholdsSearchChanged extends HouseholdsEvent {
  final String query;

  const HouseholdsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class HouseholdsFilterChanged extends HouseholdsEvent {
  final String filter;

  const HouseholdsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class HouseholdStatusUpdated extends HouseholdsEvent {
  final String householdId;
  final SurveyStatus status;
  final String? surveyId;

  const HouseholdStatusUpdated({
    required this.householdId,
    required this.status,
    this.surveyId,
  });

  @override
  List<Object?> get props => [householdId, status, surveyId];
}
