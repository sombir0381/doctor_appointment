import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../cors/widgets/empty_view.dart';
import '../../cors/widgets/loading_view.dart';
import '../../models/doctor.dart';
import '../../services/doctor_service.dart';
import 'doctor_details_screen.dart';

class SearchDoctorsScreen extends StatefulWidget {
  final String? initialSpecialty;

  const SearchDoctorsScreen({
    super.key,
    this.initialSpecialty,
  });

  @override
  State<SearchDoctorsScreen> createState() =>
      _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState
    extends State<SearchDoctorsScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];

  String? selectedSpecialty;
  double? selectedMinRating;
  double? selectedMaxFee;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadDoctors();

    _searchController.addListener(
      _applyFilters,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(
      _applyFilters,
    );
    _searchController.dispose();
    super.dispose();
  }

  void _loadDoctors() {
    setState(() {
      isLoading = true;
    });

    final List<Doctor> doctors =
    DoctorService.getDoctors();

    setState(() {
      allDoctors = doctors;

      if (widget.initialSpecialty != null &&
          widget.initialSpecialty!.isNotEmpty) {
        selectedSpecialty =
            widget.initialSpecialty;
      }

      filteredDoctors = _filterDoctors(
        doctors,
      );

      isLoading = false;
    });
  }

  List<Doctor> _filterDoctors(
      List<Doctor> doctors,
      ) {
    final String query =
    _searchController.text.trim().toLowerCase();

    return doctors.where((doctor) {
      final bool matchesSearch =
          query.isEmpty ||
              doctor.name
                  .toLowerCase()
                  .contains(query) ||
              doctor.specialty
                  .toLowerCase()
                  .contains(query) ||
              doctor.clinicName
                  .toLowerCase()
                  .contains(query) ||
              doctor.location
                  .toLowerCase()
                  .contains(query);

      final bool matchesSpecialty =
          selectedSpecialty == null ||
              selectedSpecialty!.isEmpty ||
              doctor.specialty.toLowerCase() ==
                  selectedSpecialty!.toLowerCase();

      final bool matchesRating =
          selectedMinRating == null ||
              doctor.rating >= selectedMinRating!;

      final bool matchesFee =
          selectedMaxFee == null ||
              doctor.consultationFee <=
                  selectedMaxFee!;

      return matchesSearch &&
          matchesSpecialty &&
          matchesRating &&
          matchesFee;
    }).toList();
  }

  void _applyFilters() {
    if (!mounted) {
      return;
    }

    setState(() {
      filteredDoctors = _filterDoctors(
        allDoctors,
      );
    });
  }

  List<String> _getSpecialties() {
    final Set<String> specialties = allDoctors
        .map(
          (doctor) => doctor.specialty,
    )
        .toSet();

    return specialties.toList()..sort();
  }

  void _clearFilters() {
    setState(() {
      selectedSpecialty = null;
      selectedMinRating = null;
      selectedMaxFee = null;

      _searchController.clear();

      filteredDoctors = _filterDoctors(
        allDoctors,
      );
    });
  }

  bool get hasFilters {
    return selectedSpecialty != null ||
        selectedMinRating != null ||
        selectedMaxFee != null ||
        _searchController.text
            .trim()
            .isNotEmpty;
  }

  Future<void> _openFilterSheet() async {
    String? tempSpecialty =
        selectedSpecialty;

    double? tempMinRating =
        selectedMinRating;

    double? tempMaxFee =
        selectedMaxFee;

    final List<String> specialties =
    _getSpecialties();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (
              context,
              setModalState,
              ) {
            return Container(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xFFD1D5DB,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Filter Doctors',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight:
                              FontWeight.bold,
                              color:
                              AppTheme.textColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempSpecialty =
                              null;
                              tempMinRating =
                              null;
                              tempMaxFee =
                              null;
                            });
                          },
                          child: const Text(
                            'Reset',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Specialty',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppTheme.textColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue:
                      tempSpecialty,
                      decoration:
                      InputDecoration(
                        hintText:
                        'Select specialty',
                        prefixIcon:
                        const Icon(
                          Icons
                              .medical_services_outlined,
                        ),
                        filled: true,
                        fillColor:
                        AppTheme
                            .backgroundColor,
                        border:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                          borderSide:
                          BorderSide.none,
                        ),
                      ),
                      items: [
                        const DropdownMenuItem<
                            String>(
                          value: null,
                          child: Text(
                            'All Specialties',
                          ),
                        ),
                        ...specialties.map(
                              (specialty) {
                            return DropdownMenuItem<
                                String>(
                              value: specialty,
                              child:
                              Text(
                                specialty,
                              ),
                            );
                          },
                        ),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          tempSpecialty =
                              value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppTheme.textColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      children: [
                        _RatingChip(
                          label: 'Any',
                          value: null,
                          selected:
                          tempMinRating ==
                              null,
                          onTap: () {
                            setModalState(() {
                              tempMinRating =
                              null;
                            });
                          },
                        ),
                        _RatingChip(
                          label: '4.0+',
                          value: 4.0,
                          selected:
                          tempMinRating ==
                              4.0,
                          onTap: () {
                            setModalState(() {
                              tempMinRating =
                              4.0;
                            });
                          },
                        ),
                        _RatingChip(
                          label: '4.5+',
                          value: 4.5,
                          selected:
                          tempMinRating ==
                              4.5,
                          onTap: () {
                            setModalState(() {
                              tempMinRating =
                              4.5;
                            });
                          },
                        ),
                        _RatingChip(
                          label: '4.8+',
                          value: 4.8,
                          selected:
                          tempMinRating ==
                              4.8,
                          onTap: () {
                            setModalState(() {
                              tempMinRating =
                              4.8;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Maximum Consultation Fee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppTheme.textColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FeeChip(
                          label: 'Any',
                          value: null,
                          selected:
                          tempMaxFee ==
                              null,
                          onTap: () {
                            setModalState(() {
                              tempMaxFee =
                              null;
                            });
                          },
                        ),
                        _FeeChip(
                          label: '₹500',
                          value: 500,
                          selected:
                          tempMaxFee ==
                              500,
                          onTap: () {
                            setModalState(() {
                              tempMaxFee =
                              500;
                            });
                          },
                        ),
                        _FeeChip(
                          label: '₹750',
                          value: 750,
                          selected:
                          tempMaxFee ==
                              750,
                          onTap: () {
                            setModalState(() {
                              tempMaxFee =
                              750;
                            });
                          },
                        ),
                        _FeeChip(
                          label: '₹1000',
                          value: 1000,
                          selected:
                          tempMaxFee ==
                              1000,
                          onTap: () {
                            setModalState(() {
                              tempMaxFee =
                              1000;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedSpecialty =
                                tempSpecialty;
                            selectedMinRating =
                                tempMinRating;
                            selectedMaxFee =
                                tempMaxFee;

                            filteredDoctors =
                                _filterDoctors(
                                  allDoctors,
                                );
                          });

                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openDoctorDetails(
      Doctor doctor,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DoctorDetailsScreen(
            doctor: doctor,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> specialties =
    _getSpecialties();

    return Scaffold(
      backgroundColor:
      AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Find Doctors',
        ),
        actions: [
          if (hasFilters)
            IconButton(
              tooltip: 'Clear filters',
              onPressed: _clearFilters,
              icon: const Icon(
                Icons.clear_all_rounded,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                8,
              ),
              child: Column(
                children: [
                  // SEARCH
                  TextField(
                    controller:
                    _searchController,
                    textInputAction:
                    TextInputAction.search,
                    decoration:
                    InputDecoration(
                      hintText:
                      'Search doctors, specialties...',
                      prefixIcon:
                      const Icon(
                        Icons
                            .search_rounded,
                      ),
                      suffixIcon:
                      IconButton(
                        onPressed:
                        _openFilterSheet,
                        icon: Container(
                          height: 38,
                          width: 38,
                          decoration:
                          BoxDecoration(
                            color: AppTheme
                                .primaryColor,
                            borderRadius:
                            BorderRadius
                                .circular(
                              11,
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .tune_rounded,
                            color:
                            Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // SPECIALTY CHIPS
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection:
                      Axis.horizontal,
                      children: [
                        _SpecialtyFilterChip(
                          label: 'All',
                          selected:
                          selectedSpecialty ==
                              null,
                          onTap: () {
                            setState(() {
                              selectedSpecialty =
                              null;
                              filteredDoctors =
                                  _filterDoctors(
                                    allDoctors,
                                  );
                            });
                          },
                        ),
                        ...specialties.map(
                              (specialty) {
                            return _SpecialtyFilterChip(
                              label: specialty,
                              selected:
                              selectedSpecialty ==
                                  specialty,
                              onTap: () {
                                setState(() {
                                  selectedSpecialty =
                                      specialty;
                                  filteredDoctors =
                                      _filterDoctors(
                                        allDoctors,
                                      );
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // RESULT COUNT
            if (!isLoading)
              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  10,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filteredDoctors.length} doctors found',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme
                            .secondaryTextColor,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (hasFilters)
                      TextButton(
                        onPressed:
                        _clearFilters,
                        child: const Text(
                          'Clear all',
                        ),
                      ),
                  ],
                ),
              ),

            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingView();
    }

    if (filteredDoctors.isEmpty) {
      return EmptyView(
        title: 'No doctors found',
        message:
        'Try changing your search or filters.',
        icon: Icons
            .medical_services_outlined,
      );
    }

    return ListView.separated(
      padding:
      const EdgeInsets.fromLTRB(
        20,
        4,
        20,
        28,
      ),
      itemCount: filteredDoctors.length,
      separatorBuilder: (
          context,
          index,
          ) {
        return const SizedBox(height: 14);
      },
      itemBuilder: (
          context,
          index,
          ) {
        final Doctor doctor =
        filteredDoctors[index];

        return _DoctorSearchCard(
          doctor: doctor,
          onTap: () {
            _openDoctorDetails(
              doctor,
            );
          },
        );
      },
    );
  }
}

// ======================================================
// DOCTOR CARD
// ======================================================

class _DoctorSearchCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  const _DoctorSearchCard({
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius:
      BorderRadius.circular(20),
      child: InkWell(
        borderRadius:
        BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding:
          const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _DoctorImage(
                    imageUrl:
                    doctor.profileImage,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctor.name,
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: AppTheme
                                      .textColor,
                                ),
                              ),
                            ),
                            if (doctor.verified)
                              const Icon(
                                Icons
                                    .verified_rounded,
                                color: AppTheme
                                    .secondaryColor,
                                size: 19,
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          doctor.specialty,
                          style:
                          const TextStyle(
                            fontSize: 13,
                            color: AppTheme
                                .primaryColor,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doctor.qualification,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 12,
                            color: AppTheme
                                .secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .star_rounded,
                              color:
                              Colors.amber,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              doctor.rating
                                  .toStringAsFixed(
                                1,
                              ),
                              style:
                              const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight
                                    .w700,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '(${doctor.reviewCount} reviews)',
                              style:
                              const TextStyle(
                                fontSize: 11,
                                color: AppTheme
                                    .secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 17,
                    color: AppTheme
                        .secondaryTextColor,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      doctor.location,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      const TextStyle(
                        fontSize: 12,
                        color: AppTheme
                            .secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons
                        .work_outline_rounded,
                    size: 17,
                    color: AppTheme
                        .secondaryTextColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${doctor.experienceYears} yrs',
                    style:
                    const TextStyle(
                      fontSize: 12,
                      color: AppTheme
                          .secondaryTextColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Divider(height: 1),

              const SizedBox(height: 12),

              Row(
                children: [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Consultation fee',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme
                              .secondaryTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        '₹${doctor.consultationFee.toStringAsFixed(0)}',
                        style:
                        const TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight
                              .bold,
                          color: AppTheme
                              .textColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: onTap,
                    style:
                    OutlinedButton.styleFrom(
                      minimumSize:
                      const Size(0, 40),
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 14,
                      ),
                    ),
                    child: const Text(
                      'View Details',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// DOCTOR IMAGE
// ======================================================

class _DoctorImage extends StatelessWidget {
  final String? imageUrl;

  const _DoctorImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      width: 88,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor
            .withOpacity(0.08),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: imageUrl != null &&
          imageUrl!.isNotEmpty
          ? ClipRRect(
        borderRadius:
        BorderRadius.circular(18),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (
              context,
              error,
              stackTrace,
              ) {
            return const Icon(
              Icons.person_rounded,
              size: 48,
              color:
              AppTheme.primaryColor,
            );
          },
        ),
      )
          : const Icon(
        Icons.person_rounded,
        size: 48,
        color: AppTheme.primaryColor,
      ),
    );
  }
}

// ======================================================
// SPECIALTY CHIP
// ======================================================

class _SpecialtyFilterChip
    extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpecialtyFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          onTap();
        },
        selectedColor:
        AppTheme.primaryColor,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected
              ? Colors.white
              : AppTheme.textColor,
          fontSize: 12,
          fontWeight:
          selected
              ? FontWeight.w600
              : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected
              ? AppTheme.primaryColor
              : const Color(0xFFE5E7EB),
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
      ),
    );
  }
}

// ======================================================
// RATING CHIP
// ======================================================

class _RatingChip extends StatelessWidget {
  final String label;
  final double? value;
  final bool selected;
  final VoidCallback onTap;

  const _RatingChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) ...[
            const Icon(
              Icons.star_rounded,
              size: 15,
              color: Colors.amber,
            ),
            const SizedBox(width: 3),
          ],
          Text(label),
        ],
      ),
      selected: selected,
      onSelected: (_) {
        onTap();
      },
      selectedColor:
      AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : AppTheme.textColor,
        fontWeight:
        FontWeight.w600,
      ),
      side: BorderSide(
        color: selected
            ? AppTheme.primaryColor
            : const Color(0xFFE5E7EB),
      ),
    );
  }
}

// ======================================================
// FEE CHIP
// ======================================================

class _FeeChip extends StatelessWidget {
  final String label;
  final double? value;
  final bool selected;
  final VoidCallback onTap;

  const _FeeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        onTap();
      },
      selectedColor:
      AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : AppTheme.textColor,
        fontWeight:
        FontWeight.w600,
      ),
      side: BorderSide(
        color: selected
            ? AppTheme.primaryColor
            : const Color(0xFFE5E7EB),
      ),
    );
  }
}