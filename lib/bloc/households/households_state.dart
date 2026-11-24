import 'package:equatable/equatable.dart';
import '../../models/household_model.dart';

abstract class HouseholdsState extends Equatable {
  const HouseholdsState();

  @override
  List<Object?> get props => [];
}

class HouseholdsInitial extends HouseholdsState {
  const HouseholdsInitial();
}

class HouseholdsLoading extends HouseholdsState {
  const HouseholdsLoading();
}

class HouseholdsLoaded extends HouseholdsState {
  final List<HouseholdModel> allHouseholds;
  final List<HouseholdModel> filteredHouseholds;
  final String selectedFilter;
  final String searchQuery;
  final int pendingCount;
  final int correctionCount;
  final int approvedCount;

  const HouseholdsLoaded({
    required this.allHouseholds,
    required this.filteredHouseholds,
    this.selectedFilter = 'All',
    this.searchQuery = '',
    required this.pendingCount,
    required this.correctionCount,
    required this.approvedCount,
  });

  HouseholdsLoaded copyWith({
    List<HouseholdModel>? allHouseholds,
    List<HouseholdModel>? filteredHouseholds,
    String? selectedFilter,
    String? searchQuery,
    int? pendingCount,
    int? correctionCount,
    int? approvedCount,
  }) {
    return HouseholdsLoaded(
      allHouseholds: allHouseholds ?? this.allHouseholds,
      filteredHouseholds: filteredHouseholds ?? this.filteredHouseholds,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      pendingCount: pendingCount ?? this.pendingCount,
      correctionCount: correctionCount ?? this.correctionCount,
      approvedCount: approvedCount ?? this.approvedCount,
    );
  }

  @override
  List<Object?> get props => [
        allHouseholds,
        filteredHouseholds,
        selectedFilter,
        searchQuery,
        pendingCount,
        correctionCount,
        approvedCount,
      ];
}

class HouseholdsError extends HouseholdsState {
  final String message;

  const HouseholdsError(this.message);

  @override
  List<Object?> get props => [message];
}
